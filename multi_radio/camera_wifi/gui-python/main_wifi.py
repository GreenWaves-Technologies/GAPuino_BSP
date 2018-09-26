from PyQt4 import QtGui, QtCore
import sys
import camera_wifi_ui
import serial
import cv2
import Queue
import threading
import numpy as np
import os
import socket
import scipy.misc

UDP_IP = "0.0.0.0"
UDP_PORT = 50007


class OwnImageWidget(QtGui.QWidget):
    def __init__(self, parent=None):
        super(OwnImageWidget, self).__init__(parent)
        self.image = None

    def setImage(self, image):
        self.image = image
        sz = image.size()
        self.setMinimumSize(sz)
        self.update()

    def paintEvent(self, event):
        qp = QtGui.QPainter()
        qp.begin(self)
        if self.image:
            qp.drawImage(QtCore.QPoint(0, 0), self.image)
        qp.end()


class MainApp(QtGui.QMainWindow, camera_wifi_ui.Ui_Camera_WiFIInterface):
    def __init__(self, parent=None):
        super(MainApp, self).__init__(parent)
        self.setupUi(self)
        self.serial_port = None # this is used to communicate with GAP

        self.ConnectButton.toggled.connect(self.button_proc)
        self.image_received = []
#        # configure visualization widget
        self.camera_wid = OwnImageWidget(self.camera_wid)             #real time vid visualization




    def button_proc(self):
        #START PROCEUDRE
        if self.ConnectButton.isChecked():
            self.ConnectButton.setText("Disconnect")
            print 'Inference'
            self.connection_procedure()

        #STOP PROCEDURE
        else:
            self.ConnectButton.setText("Connect")


    def pushMessage(self, text):
        self.listWidget.insertItem(0, text)


    def connection_procedure(self):
        self.pushMessage('Start the Wifi Camera Demo')
        self.sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)  # INTERNET, UDP
        self.sock.bind((UDP_IP, UDP_PORT))
        self.capture_thread = threading.Thread(target=self.grab_wifi)
        self.capture_thread.start()



    def grab_wifi(self):
        def parse_packet(payload):
            row_index = 0
            n_pixel = 0
            pixel_data = []
            data = bytearray(payload)
            for i, item in enumerate(data):
                if i is 0:
                    row_index += item
                elif i is 1:
                    row_index += item * 256
                elif i is 2:
                    n_pixel = item
                else:
                    pixel_data.append(item)
            return row_index, n_pixel, pixel_data

        l_row = []
        l_pixel = []
        l_data = []
        MAX_ROW = 324
        MAX_COL = 244
        synced = False
        count_row = 0
        count_err = 0

        while True:
            data, addr = self.sock.recvfrom(15000)  # buffer size is 1024 bytes
            row_index, n_pixel, pixel_data = parse_packet(data)
            # print row_index
            if synced is True:
                if count_row >= row_index:
                    count_row += 1
                    if row_index < count_row :
                        count_err += 1
                        l_row.append(count_row)
                    else:
                        l_row.append(row_index)
                    l_pixel.append(n_pixel)
                    l_data.append(pixel_data)
                    if row_index == MAX_ROW - 1:
                        count_row = 0
                        count_err = 0
                        image_received = l_data
                        self.plot_image_to_screen(image_received, MAX_ROW, MAX_COL)
                        l_row = []
                        l_pixel = []
                        l_data = []
                        print 'Image Received witth error: ', count_err
                        # break
                #elif row_index < count_row :
                #    print 'Data discarded: ',row_index, 'Counter:' , count_row
                #    count_row += 1
                #    l_row.append(count_row)
                #    l_pixel.append(n_pixel)
                #    l_data.append(pixel_data)
                #    #print l_data[row_index]
                #    #print pixel_data

                else:
                    synced = False
                    print 'Out of sync: ', l_row, 'received: ', row_index
                    if row_index < count_row :
                        pass
                        #print l_data[row_index]
                    else:
                        print 'next message'
                    #print pixel_data
                    count_row = 0
                    l_row = []
                    l_pixel = []
                    l_data = []
            else:
                if row_index == 0:
                    synced = True
                    count_row = 1
                    count_err = 0
                    l_row.append(row_index)
                    l_pixel.append(n_pixel)
                    l_data.append(pixel_data)




    def convert_from_byte_to_image(self, data, dim_image):
        bytes_per_row = int(dim_image/8)
        image = np.zeros((dim_image, dim_image, 1), np.uint8)
        for i in range(dim_image):
            for j in range(bytes_per_row):
                item = data[i*bytes_per_row+j]
                for bit in range(8):
                    if (item & (1<<8-1-bit)):
                        x= i
                        y= j*8+bit
                        image[x][y] = (1)
        return image

    def plot_image_to_screen(self, image, N_ROWS, N_COLS):
        scale = 4
        new_image = []
        for i in range(N_ROWS):
            for j in range(N_COLS):
                new_image.append(image[i][j])

        image = np.zeros((N_COLS, N_ROWS, 3), np.uint8)
        for j in range(N_ROWS):
            for i in range(N_COLS):
                value = new_image[j + i * N_ROWS]
                image[i][j][:] = (value,value,value)

        height, width, bmp = image.shape
        bpl = 1 * width
        #plot_image = cv2.flip(plot_image, 0)  # flip horiontally
        plot_image = QtGui.QImage(image, width, height, image.strides[0], QtGui.QImage.Format_RGB888)
        self.camera_wid.setImage(plot_image)


    def save_image_to_folder(self,image0, image1, image2,dim_image):
        image = np.zeros((dim_image*3, dim_image, 1), np.uint8)
        path = DATASET_PATH + LABELLING_PATH + self.current_label + '/'+ self.get_next_file_name()+ '.png'
        image[0:dim_image] = image0
        image[dim_image:2*dim_image] = image1
        image[2*dim_image:3*dim_image] = image2
        print(path)
        scipy.misc.toimage(image.squeeze()*255, cmin=0.0, cmax=1.0).save(path)

    def open_image_from_folder(self):
        pass

app = QtGui.QApplication(sys.argv)  # create application
ui = MainApp()  # init main window
ui.show()
sys.exit(app.exec_())

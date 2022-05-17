package de.neemann.digiblock.gui.components.terminal.Serial;

import purejavacomm.*;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.TooManyListenersException;

public class SerialTool {

    public static final ArrayList<String> findPorts() {

        // 获得当前所有可用串口
        Enumeration<CommPortIdentifier> portList = CommPortIdentifier.getPortIdentifiers();
        ArrayList<String> portNameList = new ArrayList<String>();
        // 将可用串口名添加到List并返回该List
        while (portList.hasMoreElements()) {

            String portName = portList.nextElement().getName();
            portNameList.add(portName);
        }
        return portNameList;
    }

    /**
     * 打开串口
     *
     * @param portName
     *            端口名称
     * @param baudrate
     *            波特率
     * @return 串口对象
     */
    public static final SerialPort openPort(String portName, Integer baudrate) throws PortInUseException {


        try {


            // 通过端口名识别端口
            CommPortIdentifier portIdentifier = CommPortIdentifier.getPortIdentifier(portName);

            // 打开端口，并给端口名字和一个timeout（打开操作的超时时间）
            CommPort commPort = portIdentifier.open(portName, 2000);

            // 判断是不是串口
            if (commPort instanceof SerialPort) {

                SerialPort serialPort = (SerialPort) commPort;
                try {

                    // 设置一下串口的波特率等参数
                    serialPort.setSerialPortParams(baudrate, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
                    //logger.info("串口" + portName + "打开成功");
                } catch (UnsupportedCommOperationException e) {

                    //logger.error("设置串口" + portName + "参数失败：" + e.getMessage());
                    //throw e;
                    e.printStackTrace();
                }

                return serialPort;

            }
        } catch (NoSuchPortException e1) {
            e1.printStackTrace();
        }
        return null;
    }

    /**
     * 关闭串口
     *
     */
    public static void closePort(SerialPort serialPort) {

        if (serialPort != null) {

            serialPort.close();
        }
    }

    /**
     * 往串口发送数据
     *
     * @param order
     *            待发送数据
     */
    public static void sendToPort(SerialPort serialPort, byte[] order) {


        OutputStream out = null;

        try {
            out = serialPort.getOutputStream();
            out.write(order);
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {

            try {

                if (out != null) {

                    out.close();
                    out = null;
                }
            } catch (IOException e) {

                e.printStackTrace();
            }
        }

    }

    /**
     * 从串口读取数据
     *
     * @param serialPort
     *            当前已建立连接的SerialPort对象
     * @return 读取到的数据
     */
    public static byte[] readFromPort(SerialPort serialPort) {


        InputStream in = null;
        byte[] bytes = null;
        try {
            in = serialPort.getInputStream();
            int buffLength = in.available();
            while (buffLength != 0) {
                bytes = new byte[buffLength];
                in.read(bytes);
                buffLength = in.available();
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return bytes;
    }

    /**
     * 添加监听器
     *
     * @param serialPort
     *            串口对象
     * @param listener
     *            串口监听器
     * @throws TooManyListenersException
     *             监听类对象过多
     */
    public static void addListener(SerialPort serialPort, SerialPortEventListener listener) {
        try {
            serialPort.addEventListener(listener);
            serialPort.notifyOnDataAvailable(true);
            serialPort.notifyOnBreakInterrupt(true);

        } catch (TooManyListenersException e) {
            e.printStackTrace();
        }
    }


}

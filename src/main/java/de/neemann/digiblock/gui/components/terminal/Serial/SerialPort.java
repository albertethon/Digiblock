package de.neemann.digiblock.gui.components.terminal.Serial;

import de.neemann.digiblock.core.Node;
import de.neemann.digiblock.core.NodeException;
import de.neemann.digiblock.core.ObservableValue;
import de.neemann.digiblock.core.ObservableValues;
import de.neemann.digiblock.core.element.Element;
import de.neemann.digiblock.core.element.ElementAttributes;
import de.neemann.digiblock.core.element.ElementTypeDescription;
import de.neemann.digiblock.core.element.Keys;
import de.neemann.digiblock.draw.elements.PinException;
import de.neemann.digiblock.gui.components.terminal.Keyboard;
import de.neemann.digiblock.gui.components.terminal.Terminal;
import de.neemann.digiblock.gui.components.terminal.TerminalDialog;

import javax.swing.*;
import java.awt.*;

import static de.neemann.digiblock.core.element.PinInfo.input;

public class SerialPort extends Node implements Element {

    /**
     * The serialport description
     */
    public static final ElementTypeDescription DESCRIPTION
            = new ElementTypeDescription(SerialPort.class,
            input("C").setClock(),
            input("DI"))
            .addAttribute(Keys.ROTATE)
            .addAttribute(Keys.LABEL);

    private final String label;
    private final ElementAttributes attr;
    private SerialDialog serialDialog;
    private ObservableValue clock;
    private boolean lastClock = false;
    private ObservableValue dataIn;
    private final ObservableValue dataOut;

    public SerialPort(ElementAttributes attributes) {
        attr = attributes;
        label = attributes.getLabel();
        dataOut = new ObservableValue("DO", 8)
                .setToHighZ()
                .setPinDescription(DESCRIPTION);
    }

    @Override
    public void readInputs() throws NodeException {

        boolean clockVal = clock.getBool();
        if (!lastClock && clockVal) {
            long value = dataIn.getValue();
            if (value != 0) {
                if (serialDialog != null) {
                    byte[] data = new byte[1];
                    data[0] = (byte) value;
                    serialDialog.sendData(data);
                }

            }
        }
        lastClock = clockVal;
    }

    @Override
    public void writeOutputs() throws NodeException {
        if (serialDialog != null) {
            dataOut.setValue(serialDialog.getReadData());
        } else {
            dataOut.setValue(0);
        }
    }

    @Override
    public void setInputs(ObservableValues inputs) throws NodeException {
        clock = inputs.get(0).addObserverToValue(this).checkBits(1, this, 0);
        dataIn = inputs.get(1).addObserverToValue(this).checkBits(8, this, 1);

    }

    @Override
    public ObservableValues getOutputs() throws PinException {
        return new ObservableValues(dataOut);
    }

    /**
     * Sets the SerialDialog
     */
    public void setSerial(SerialDialog serialDialog) {
        this.serialDialog = serialDialog;
    }

    @Override
    protected void finalize() throws Throwable {
        if (serialDialog.isOpen()) {
            serialDialog.close();
        }
    }
}

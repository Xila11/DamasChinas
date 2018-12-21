package com.dmc.game;

import java.io.Closeable;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class FileHandler {

	public static synchronized void saveObject(Object obj, String fileName) {

		FileOutputStream fout = null;
		ObjectOutputStream oos = null;
		try {
			fout = new FileOutputStream(fileName);
			oos = new ObjectOutputStream(fout);
			oos.writeObject(obj);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			close(oos);
			close(fout);
		}
	}

	public static synchronized Object readObject(String fileName) {

		FileInputStream input = null;
		ObjectInputStream oin = null;
		Object obj = null;
		try {
			input = new FileInputStream(fileName);
			oin = new ObjectInputStream(input);
			obj = oin.readObject();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			close(oin);
			close(input);
		}

		return obj;
	}

	private static void close(Closeable file) {

		if (file != null) {
			try {
				file.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}

}

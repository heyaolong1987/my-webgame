package com.netease.webgame.bitchwar.Convert;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.HashMap;
import java.util.zip.Deflater;

import org.apache.xpath.functions.Function;

import com.netease.webgame.bitchwar.model.vo.charactor.CharactorVO;

import flex.messaging.io.SerializationContext;
import flex.messaging.io.amf.Amf3Input;
import flex.messaging.io.amf.Amf3Output;

public class ConvertDataType {
	private static SerializationContext context = new SerializationContext();  
	public static Object byteArrayToObject(byte[] byteArr){
		try {    
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(byteArr);
			ObjectInputStream objectInputStream = new ObjectInputStream(byteArrayInputStream);
			Integer len = objectInputStream.readInt();
			Object obj = objectInputStream.readObject();
			byteArrayInputStream.close();
			objectInputStream.close();
			return obj;
		}
		catch (Exception ex) {
			return null;
		} 
	}
	public static Object flashByteArrayToObject(byte[] byteArr){
		try{			
			Amf3Input amf3Input = new Amf3Input(context);
			amf3Input.setInputStream(new ByteArrayInputStream(byteArr));
			int len = amf3Input.readInt();
			Object obj = amf3Input.readObject();
			return obj;
		}
		catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

	public static byte[] objectToFlashByteArray(Object obj){
		try{
			Amf3Output amfOut = new Amf3Output(new SerializationContext());

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();

			DataOutputStream dataOutStream = new DataOutputStream(byteArrayOutputStream);

			amfOut.setOutputStream(dataOutStream);

			amfOut.writeObject(obj);

			amfOut.flush();

			dataOutStream.flush();

			byte[] msg = byteArrayOutputStream.toByteArray();

			amfOut.close();

			dataOutStream.close();
			return msg;
		}
		catch(IOException ex){
			return null;
		}


	}


	private static Deflater deflater = new Deflater();

	private static int CACHE_SIZE = 1024;
	/**
	 * Ñ¹Ëõ×Ö½Ú
	 * @param input
	 * @return
	 * @throws IOException
	 */
	public static byte[] compress(byte[] input) throws IOException{
		deflater.reset();
		deflater.setInput(input);
		deflater.finish();
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream(input.length);
		byte[] buf = new byte[CACHE_SIZE];
		int len;
		while(!deflater.finished()){
			len = deflater.deflate(buf);
			outputStream.write(buf,0,len);
		}
		byte[] tmpByte = outputStream.toByteArray();
		outputStream.close();
		return tmpByte;
	}
	
	public static CharactorVO HashMapToCharactorVO(HashMap map){
		CharactorVO charVO = new CharactorVO();
		charVO.createTime = Long.parseLong(map.get("createTime").toString());
		charVO.energy =  Integer.parseInt(map.get("energy").toString());
		charVO.level = Integer.parseInt(map.get("level").toString());
		charVO.exp = Integer.parseInt(map.get("exp").toString());
		charVO.id = Integer.parseInt(map.get("id").toString());
		charVO.name = map.get("name").toString();
		charVO.exp = Integer.parseInt(map.get("exp").toString());
		return charVO;
	}
	
}

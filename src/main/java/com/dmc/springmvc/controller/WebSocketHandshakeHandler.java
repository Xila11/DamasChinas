package com.dmc.springmvc.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeFailureException;
import org.springframework.web.socket.server.HandshakeHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

public class WebSocketHandshakeHandler implements HandshakeHandler {

	@Override
	public boolean doHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler,
			Map<String, Object> attributes) throws HandshakeFailureException {
		
		System.out.println("Handshaking Started ");
		boolean ret = false;
		try {
			response.getHeaders().add("Access-Control-Allow-Credentials", "true");
			response.getHeaders().add("Access-Control-Allow-Header", "x-websocket-protocol");
			response.getHeaders().add("Access-Control-Allow-Header", "x-websocket-version");
			response.getHeaders().add("Access-Control-Allow-Header", "x-websocket-extensions");
			response.getHeaders().add("Access-Control-Allow-Header", "authorization");
			response.getHeaders().add("Access-Control-Allow-Header", "content-type");
			
			if(request.getHeaders().containsKey("Sec-WebSocket-Extensions")) {  
	            request.getHeaders().set("Sec-WebSocket-Extensions", "permessage-deflate");  
	         } 

			DefaultHandshakeHandler obj = new DefaultHandshakeHandler();
			ret = obj.doHandshake(request, response, wsHandler, attributes);
			response.setStatusCode(HttpStatus.SWITCHING_PROTOCOLS);
			System.out.println("Handshaked status " + ret);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return ret;
	}

}

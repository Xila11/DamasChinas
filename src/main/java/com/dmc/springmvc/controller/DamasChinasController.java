package com.dmc.springmvc.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import java.util.jar.JarFile;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.dmc.game.Ball;
import com.dmc.game.FileHandler;
import com.dmc.game.Game;
import com.dmc.game.Utils;

import sun.net.www.protocol.jar.URLJarFile;

@Controller
@RequestMapping("/")
public class DamasChinasController {

	final static private String[] users = { "dilan", "carlos", "adrian" };

	final static private String white = "#6_5,#6_6,#6_7,#6_8" + "#7_4,#7_5,#7_6,#7_7,#7_8"
			+ "#8_3,#8_4,#8_5,#8_6,#8_7,#8_8" + "#9_2,#9_3,#9_4,#9_5,#9_6,#9_7,#9_8"
			+ "#10_3,#10_4,#10_5,#10_6,#10_7,#10_8" + "#11_4,#11_5,#11_6,#11_7,#11_8" + "#12_5,#12_6,#12_7,#12_8";

	final static private String BLUE = "rgb(0, 0, 255)";

	private static Map<String, String> userMap;

	@Autowired
	private SimpMessagingTemplate template;

	@PostConstruct
	public void init() {
		userMap = new HashMap<>();
		userMap.put("dilan", "dilan");
		userMap.put("carlos", "carlos");
		userMap.put("adrian", "adrian");
		userMap.put("gsilva", "gsilva");
		userMap.put("chavarin", "chavarin");
		userMap.put("luis", "luis");
		userMap.put("david", "david");
		userMap.put("daniel", "daniel");
		userMap.put("apo", "apo");
		userMap.put("pablo", "pablo");
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView gameHome(HttpSession session) {
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		session.setAttribute("username", userDetails.getUsername());
		ModelAndView mav = new ModelAndView("index");
		mav.addObject("users", userMap);
		return mav;
	}

	@RequestMapping(value = "/history", method = RequestMethod.GET)
	public ModelAndView getHistory(ModelMap model, @RequestParam("userName") String username) {
		ModelAndView obj = new ModelAndView("history");
		obj.addObject("userName", username);
		template.convertAndSend("/topic", "message");
		return obj;
	}

	@ResponseBody
	@RequestMapping(value = "/startGame")
	public Game startGame(final HttpSession session, @RequestParam("userName") String username) {

		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		System.out.println(userDetails.getUsername());
		session.setAttribute("username", userDetails.getUsername());

		String gameId = Utils.getGameId(userDetails.getUsername(), username);

		// List<String> ob = new ArrayList<String>();

		Game game = null;
		if (new File(gameId.concat(".ser")).exists()) {
			game = (Game) FileHandler.readObject(gameId.concat(".ser"));
		} else {

			game = new Game();
			game.setfUser(userDetails.getUsername());
			game.setsUser(username);
			game.setTurn(userDetails.getUsername());
			game.setGameId(gameId);			

			game.add(new Ball("1", "#1_1", "red"));
			game.add(new Ball("1", "#2_1", "red"));
			game.add(new Ball("1", "#2_2", "red"));
			game.add(new Ball("1", "#3_1", "red"));
			game.add(new Ball("1", "#3_2", "red"));
			game.add(new Ball("1", "#3_3", "red"));
			game.add(new Ball("1", "#4_1", "red"));
			game.add(new Ball("1", "#4_2", "red"));
			game.add(new Ball("1", "#4_3", "red"));
			game.add(new Ball("1", "#4_4", "red"));
			game.add(new Ball("1", "#5_5", "red"));
			game.add(new Ball("1", "#5_6", "red"));
			game.add(new Ball("1", "#5_7", "red"));
			game.add(new Ball("1", "#5_8", "red"));
			game.add(new Ball("1", "#5_9", "red"));

			game.add(new Ball("1", "#17_1", "blue"));
			game.add(new Ball("1", "#16_1", "blue"));
			game.add(new Ball("1", "#16_2", "blue"));
			game.add(new Ball("1", "#15_1", "blue"));
			game.add(new Ball("1", "#15_2", "blue"));
			game.add(new Ball("1", "#15_3", "blue"));
			game.add(new Ball("1", "#14_1", "blue"));
			game.add(new Ball("1", "#14_2", "blue"));
			game.add(new Ball("1", "#14_3", "blue"));
			game.add(new Ball("1", "#14_4", "blue"));
			game.add(new Ball("1", "#13_5", "blue"));
			game.add(new Ball("1", "#13_6", "blue"));
			game.add(new Ball("1", "#13_7", "blue"));
			game.add(new Ball("1", "#13_8", "blue"));
			game.add(new Ball("1", "#13_9", "blue"));

			FileHandler.saveObject(game, gameId.concat(".ser"));
		}

		return game;
	}

	@ResponseBody
	@RequestMapping(value = "/move", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public Game move(@RequestParam("deSelect") String deSelect, @RequestParam("select") String select,
			@RequestParam("color") String color, @RequestParam("userName") String username) {
		Game game = null;
		try {
			UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication()
					.getPrincipal();

			String gameId = Utils.getGameId(userDetails.getUsername(), username);

			game = (Game) FileHandler.readObject(gameId.concat(".ser"));

			// System.out.println(deSelect + " " + select + "---" +
			// Utils.validateMove(game, deSelect, select));
			if (Utils.validateMove(game, deSelect, select)) {
				game.setValid(true);
			} else {
				game.setValid(false);
				return game;
			}

			if (game.getColor(select) == null
					|| (game.getColor(select) != null && (game.getColor(select).equalsIgnoreCase("red")
							|| game.getColor(select).equalsIgnoreCase("blue")))) {

				FileHandler.saveObject(game, gameId.concat("1.ser"));

				if (color.equalsIgnoreCase(BLUE)) {
					game.move("#" + deSelect, "#" + select, "blue");
					if (game.getfColor() == null) {
						game.setfColor("blue");
					}
				} else {
					game.move("#" + deSelect, "#" + select, "red");
					if (game.getfColor() == null) {
						game.setfColor("red");
					}
				}

				game.getBalls()
						.add(new Ball("1", "#" + deSelect, (white.contains("#" + deSelect) ? "white" : "darkgray")));

				if (userDetails.getUsername().equalsIgnoreCase(game.getfUser())) {
					game.setTurn(game.getsUser());
				} else {
					game.setTurn(game.getfUser());
				}
				

				FileHandler.saveObject(game, gameId.concat(".ser"));
				/*
				 * for (Ball ball : game.getBalls()) { System.out.println(ball);
				 * }
				 */
			}
			template.convertAndSend("/topic/".concat(gameId), game);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return game;
	}

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping(value = "/setCall") public Game setCall() { UserDetails
	 * userDetails = (UserDetails)
	 * SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	 * 
	 * String gameId = Utils.getGameId(userDetails.getUsername(), username);
	 * 
	 * Game game = null; if (new File(gameId.concat(".ser")).exists()) { game =
	 * (Game) FileHandler.readObject(gameId.concat(".ser"));
	 * System.out.println(userDetails.getUsername()); }
	 * 
	 * return game; }
	 */
	@ResponseBody
	@RequestMapping(value = "/removeFile")
	public AjaxResponseBody removeFile(@RequestParam("userName") String username) {

		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String gameId = Utils.getGameId(userDetails.getUsername(), username);

		Game game = new Game();
		game.setfUser(userDetails.getUsername());
		game.setsUser(username);
		game.setTurn(userDetails.getUsername());
		game.setGameId(gameId);

		game.add(new Ball("1", "#1_1", "red"));
		game.add(new Ball("1", "#2_1", "red"));
		game.add(new Ball("1", "#2_2", "red"));
		game.add(new Ball("1", "#3_1", "red"));
		game.add(new Ball("1", "#3_2", "red"));
		game.add(new Ball("1", "#3_3", "red"));
		game.add(new Ball("1", "#4_1", "red"));
		game.add(new Ball("1", "#4_2", "red"));
		game.add(new Ball("1", "#4_3", "red"));
		game.add(new Ball("1", "#4_4", "red"));
		game.add(new Ball("1", "#5_5", "red"));
		game.add(new Ball("1", "#5_6", "red"));
		game.add(new Ball("1", "#5_7", "red"));
		game.add(new Ball("1", "#5_8", "red"));
		game.add(new Ball("1", "#5_9", "red"));

		game.add(new Ball("1", "#17_1", "blue"));
		game.add(new Ball("1", "#16_1", "blue"));
		game.add(new Ball("1", "#16_2", "blue"));
		game.add(new Ball("1", "#15_1", "blue"));
		game.add(new Ball("1", "#15_2", "blue"));
		game.add(new Ball("1", "#15_3", "blue"));
		game.add(new Ball("1", "#14_1", "blue"));
		game.add(new Ball("1", "#14_2", "blue"));
		game.add(new Ball("1", "#14_3", "blue"));
		game.add(new Ball("1", "#14_4", "blue"));
		game.add(new Ball("1", "#13_5", "blue"));
		game.add(new Ball("1", "#13_6", "blue"));
		game.add(new Ball("1", "#13_7", "blue"));
		game.add(new Ball("1", "#13_8", "blue"));
		game.add(new Ball("1", "#13_9", "blue"));

		FileHandler.saveObject(game, gameId.concat(".ser"));

		return new AjaxResponseBody();
	}

	@ResponseBody
	@RequestMapping(value = "/getHistoryGame", method = RequestMethod.POST)
	public Game getHistoryGame(@RequestParam("userName") String username) {
		
		try {
			URL url = new URL(
					"jar:http://central.maven.org/maven2/log4j/log4j/1.2.15/log4j-1.2.15.jar!/org/apache/log4j/Level.class");
			url.openStream();
			System.out.println("");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	
		/*InputStream in = null;
		try {
			URL url = new URL(
					"jar:http://central.maven.org/maven2/log4j/log4j/1.2.15/log4j-1.2.15.jar!/org/apache/log4j/Level.class");
			in = url.openConnection().getInputStream();
			Path tmpFile = Files.createTempFile("jar_cache_dilan", null);
			Files.copy(in, tmpFile, StandardCopyOption.REPLACE_EXISTING);
			JarFile jarFile = new URLJarFile(tmpFile.toFile(), null);
			tmpFile.toFile().deleteOnExit();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}*/
	

		
		
		UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		String gameId = Utils.getGameId(userDetails.getUsername(), username);
		Game game = null;
		if (new File(gameId.concat("1.ser")).exists()) {
			game = (Game) FileHandler.readObject(gameId.concat("1.ser"));
		}

		return game;
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
		}
		return "/";
	}
	
	@ResponseBody
	@RequestMapping(value = "/msg", method = RequestMethod.GET)
	public String msg() {
		ArrayList<WebSocketSession> sessions = GreetingHandler.sessions;
		if(sessions.size() >0)
		{
			for (WebSocketSession webSocketSession : sessions) {
				System.out.println(webSocketSession.getId());
				 if (webSocketSession.isOpen()) {
					 try {
						webSocketSession.sendMessage(new TextMessage("Method called."+webSocketSession.getId()));
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	                }
			}
		}
		return "Done!!!!";
	}

}

package com.dmc.game;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonView;

public class Game implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4369382297350923371L;

	@JsonView(Views.Public.class)
	private String fUser;

	@JsonView(Views.Public.class)
	private String sUser;
	
	@JsonView(Views.Public.class)
	private String turn;
	
	@JsonView(Views.Public.class)
	private String gameId;
	
	@JsonView(Views.Public.class)
	private String fColor;
	
	@JsonView(Views.Public.class)
	transient private boolean valid;
	
	@JsonView(Views.Public.class)
	private List<Ball> balls;	
	
	

	public Game() {
		super();
	}

	public String getGameId() {
		return gameId;
	}


	public void setGameId(String gameId) {
		this.gameId = gameId;
	}

	public String getfUser() {
		return fUser;
	}

	public void setfUser(String fUser) {
		this.fUser = fUser;
	}

	public String getsUser() {
		return sUser;
	}

	public void setsUser(String sUser) {
		this.sUser = sUser;
	}

	public String getTurn() {
		return turn;
	}

	public void setTurn(String turn) {
		this.turn = turn;
	}	

	public String getfColor() {
		return fColor;
	}

	public void setfColor(String fColor) {
		this.fColor = fColor;
	}

	public List<Ball> getBalls() {
		return balls;
	}

	public void setBalls(List<Ball> balls) {
		this.balls = balls;
	}
	
	public void add(Ball ball) {
		if (balls == null) {
			balls = new ArrayList<Ball>();
		}
		balls.add(ball);
	}
	
	
	public boolean isValid() {
		return valid;
	}

	public void setValid(boolean valid) {
		this.valid = valid;
	}

	public void move(String start, String end, String color) {
		Ball ballStart = null;
		Ball ballEnd = null;
		if (balls != null && balls.size() > 0) {
			for (Ball ball : balls) {
				if (ball.getIndex().equalsIgnoreCase(start)) {
					ballStart = ball;
				} else if (ball.getIndex().equalsIgnoreCase(end)) {
					ballEnd = ball;

				}
			}
		}

		if (ballEnd != null) {
			balls.remove(ballEnd);
		}

		if (ballStart != null) {
			ballStart.setIndex(end);
			ballStart.setColor(color);
		}
	}
	
	public String getColor(String index){		
		if (balls != null && balls.size() > 0) {
			for (Ball ball : balls) {
				if (ball.getIndex().equalsIgnoreCase(index)) {
					return ball.getColor();
				}				
			}
		}		
		return null;
	}	
}

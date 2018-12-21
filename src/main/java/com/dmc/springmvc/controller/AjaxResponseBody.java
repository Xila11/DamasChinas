package com.dmc.springmvc.controller;

import java.util.ArrayList;
import java.util.List;

import com.dmc.game.Ball;
import com.dmc.game.Views;
import com.fasterxml.jackson.annotation.JsonView;

public class AjaxResponseBody {

	@JsonView(Views.Public.class)
	List<Ball> balls;

	public void add(Ball ball) {
		if (balls == null) {
			balls = new ArrayList<Ball>();
		}
		balls.add(ball);
	}

}

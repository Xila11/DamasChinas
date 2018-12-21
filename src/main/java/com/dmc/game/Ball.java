package com.dmc.game;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonView;

public class Ball implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2919899563027210780L;

	@JsonView(Views.Public.class)
	private String row;

	@JsonView(Views.Public.class)
	private String index;
	
	@JsonView(Views.Public.class)
	private String color;

	public Ball(String row, String index, String color) {
		super();
		this.row = row;
		this.index = index;
		this.color = color;
	}

	public String getRow() {
		return row;
	}

	public void setRow(String row) {
		this.row = row;
	}

	public String getIndex() {
		return index;
	}

	public void setIndex(String index) {
		this.index = index;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
	
	

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((color == null) ? 0 : color.hashCode());
		result = prime * result + ((index == null) ? 0 : index.hashCode());
		result = prime * result + ((row == null) ? 0 : row.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Ball other = (Ball) obj;
		if (color == null) {
			if (other.color != null)
				return false;
		} else if (!color.equals(other.color))
			return false;
		if (index == null) {
			if (other.index != null)
				return false;
		} else if (!index.equals(other.index))
			return false;
		if (row == null) {
			if (other.row != null)
				return false;
		} else if (!row.equals(other.row))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "Ball [row=" + row + ", index=" + index + ", color=" + color + "]";
	}
	
	
	
	

}

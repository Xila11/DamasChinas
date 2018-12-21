package com.dmc.game;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

final public class Utils {

	private static final String RED_BLUE = "red,blue";

	private static final Map<Integer, Integer> rowMap = new HashMap<>();

	private static final Map<Integer, Integer> rowDifMap = new HashMap<>();

	static {
		rowMap.put(1, 1);
		rowMap.put(2, 2);
		rowMap.put(3, 3);
		rowMap.put(4, 4);
		rowMap.put(5, 13);

		rowMap.put(6, 12);
		rowMap.put(7, 11);
		rowMap.put(8, 10);

		rowMap.put(9, 9);

		rowMap.put(10, 10);
		rowMap.put(11, 11);
		rowMap.put(12, 12);

		rowMap.put(13, 13);
		rowMap.put(14, 4);
		rowMap.put(15, 3);
		rowMap.put(16, 2);
		rowMap.put(17, 1);

		/*
		 * rowDifMap.put(1, 1); rowDifMap.put(2, 2); rowDifMap.put(3, 3);
		 * rowDifMap.put(4, 4); rowDifMap.put(5, 13);
		 * 
		 * rowDifMap.put(6, 12); rowDifMap.put(7, 11); rowDifMap.put(8, 10);
		 * 
		 * rowDifMap.put(9, 9);
		 * 
		 * rowDifMap.put(10, 10); rowDifMap.put(11, 11); rowDifMap.put(12, 12);
		 * 
		 * rowDifMap.put(13, 13); rowDifMap.put(14, 4); rowDifMap.put(15, 3);
		 * rowDifMap.put(16, 2); rowDifMap.put(17, 1);
		 */

	}

	public static String getGameId(String sUser, String iUser) {

		if (sUser.compareTo(iUser) < 0) {
			return sUser.concat(iUser);
		}
		return iUser.concat(sUser);

	}

	public static boolean validateMove(Game game, String deselect, String select) {

		Map<String, String> colorMap = new HashMap<>();
		Map<String, String> visited = new HashMap<>();

		if (game.getBalls() != null && game.getBalls().size() > 0) {
			for (Ball ball : game.getBalls()) {
				colorMap.put(ball.getIndex(), ball.getColor());
			}
		}

		String[] start = deselect.split("_");
		String[] end = select.split("_");

		int sx = Integer.parseInt(start[0]), sy = Integer.parseInt(start[1]);
		LinkedList<Point> next = new LinkedList<Point>();
		visited.put(deselect, deselect);

		// movement is only one spot.

		// generates 6 possible positions.
		Point[] pts = getPossiblePts(sx, sy);

		// first movement
		for (int i = 0; i < 6; i++) {
			if (pts[i] != null) {
				String index = String.valueOf(pts[i].x) + "_" + String.valueOf(pts[i].y);
				visited.put(index, index);
				if (index.equals(select) && (colorMap.get("#" + index) == null
						|| ((colorMap.get("#" + index) != null && !RED_BLUE.contains(colorMap.get("#" + index)))))) {
					return true;
				}
				if (index.equals(select)
						&& ((colorMap.get("#" + index) != null && RED_BLUE.contains(colorMap.get("#" + index))))) {
					return false;
				} else if (colorMap.get("#" + index) != null && RED_BLUE.contains(colorMap.get("#" + index))) {

					Point pt = null;
					switch (i) {
					case 0:// x,y-1
						pt = new Point(pts[i].x, pts[i].y + 1);
						break;
					case 1:// top left
						pt = getLeftTop(pts[i].x, pts[i].y);
						break;
					case 2:// top right
						pt = getRightTop(pts[i].x, pts[i].y);
						break;
					case 3:// x,y+1
						pt = new Point(pts[i].x, pts[i].y - 1);
						break;
					case 4: // bottom right
						pt = getRightBottom(pts[i].x, pts[i].y);
						break;
					case 5: // bottom left
						pt = getLeftBottom(pts[i].x, pts[i].y);
						break;
					default:
					}

					if (pt != null) {
						next.add(pt);
					}
				}

			}
		}

		// next jumps
		return

		jumpOver(next, colorMap, select, visited);

	}

	private static boolean jumpOver(LinkedList<Point> next, Map<String, String> colorMap, String select,
			Map<String, String> visited) {
		if (next.isEmpty()) {
			return false;
		} else {
			Point pont = next.remove();
			String index = String.valueOf(pont.x) + "_" + String.valueOf(pont.y);
			visited.put(index, index);
			if (index.equals(select) && (colorMap.get("#" + index) == null || (colorMap.get("#" + index) != null
					|| (colorMap.get("#" + index) != null && !RED_BLUE.contains(colorMap.get("#" + index)))))) {
				return true;
			} else if (colorMap.get("#" + index) == null
					|| (colorMap.get("#" + index) != null && !RED_BLUE.contains(colorMap.get("#" + index)))) {
				Point[] nextJump = getPossiblePts(pont.x, pont.y);

				Point pt = null;

				if (nextJump[0] != null) {
					String index1 = String.valueOf(nextJump[0].x) + "_" + String.valueOf(nextJump[0].y);
					if (colorMap.get("#" + index1) != null && RED_BLUE.contains(colorMap.get("#" + index1))
							&& nextJump[0].y - 1 < 14) {
						pt = new Point(nextJump[0].x, nextJump[0].y + 1);
						if (pt != null && visited.get(pt.getIndex()) == null) {
							next.add(pt);
						}
					}
				}

				if (nextJump[1] != null) {
					String index2 = String.valueOf(nextJump[1].x) + "_" + String.valueOf(nextJump[1].y);
					if (colorMap.get("#" + index2) != null && RED_BLUE.contains(colorMap.get("#" + index2))) {
						pt = getLeftTop(nextJump[1].x, nextJump[1].y);
						if (pt != null && visited.get(pt.getIndex()) == null) {
							next.add(pt);
						}
					}
				}

				if (nextJump[2] != null) {
					String index3 = String.valueOf(nextJump[2].x) + "_" + String.valueOf(nextJump[2].y);
					if (colorMap.get("#" + index3) != null && RED_BLUE.contains(colorMap.get("#" + index3))) {
						pt = getRightTop(nextJump[2].x, nextJump[2].y);
						if (pt != null && visited.get(pt.getIndex()) == null) {
							next.add(pt);
						}
					}
				}

				if (nextJump[3] != null) {
					String index4 = String.valueOf(nextJump[3].x) + "_" + String.valueOf(nextJump[3].y);
					if (colorMap.get("#" + index4) != null && RED_BLUE.contains(colorMap.get("#" + index4))
							&& nextJump[3].y - 1 > 0) {
						pt = new Point(nextJump[3].x, nextJump[3].y - 1);
						if (pt != null && visited.get(pt.getIndex()) == null) {
							next.add(pt);
						}
					}
				}

				if (nextJump[4] != null) {
					String index5 = String.valueOf(nextJump[4].x) + "_" + String.valueOf(nextJump[4].y);
					if (colorMap.get("#" + index5) != null && RED_BLUE.contains(colorMap.get("#" + index5))) {
						pt = getRightBottom(nextJump[4].x, nextJump[4].y);
						if (pt != null && visited.get(pt.getIndex()) == null) {
							next.add(pt);
						}
					}
				}
				if (nextJump[5] != null) {
					String index6 = String.valueOf(nextJump[5].x) + "_" + String.valueOf(nextJump[5].y);
					if (colorMap.get("#" + index6) != null && RED_BLUE.contains(colorMap.get("#" + index6))) {
						pt = getLeftBottom(nextJump[5].x, nextJump[5].y);
						if (pt != null && visited.get(pt.getIndex()) == null) {
							next.add(pt);
						}
					}
				}
			}

			return jumpOver(next, colorMap, select, visited);
		}

	}

	// x is # of row and y # of balls per row.
	public static Point[] getPossiblePts(int sx, int sy) {
		Point[] pts = new Point[6];

		// adjustments. when change from 4 <==> 5, 13<==>14
		int dy = 0;
		int ty = 0;

		int ddy = 0;
		int tty = 0;

		if (sx == 4) {
			dy = 4;
		} else if (sx == 5) {
			ty = -4;
		}

		else if (sx == 14) {
			ddy = 4;
		} else if (sx == 13) {
			tty = -4;
		}

		if ((sx >= 1 && sx <= 17) && 0 < sy + 1 && sy + 1 <= rowMap.get(sx)) {
			pts[0] = new Point(sx, sy + 1);
		}

		if (sx + 1 >= 1 && sx + 1 <= 17) {
			if (rowMap.get(sx + 1) > rowMap.get(sx)) {
				if (sy + 1 > 0 && sy + 1 <= rowMap.get(sx + 1)) {
					pts[1] = new Point(sx + 1, sy + 1 + dy);
				}
				if (0 < sx + 1 && sx + 1 <= rowMap.get(sx + 1)) {
					pts[2] = new Point(sx + 1, sy + dy);
				}
			} else {
				if (rowMap.get(sx + 1) >= sy + tty && sy + tty > 0) {
					pts[1] = new Point(sx + 1, sy + tty);
				}
				if (rowMap.get(sx + 1) >= sy - 1 + tty && sy - 1 + tty > 0) {
					pts[2] = new Point(sx + 1, sy - 1 + tty);
				}

			}
		}

		if ((sx >= 1 && sx <= 17) && rowMap.get(sx) >= sy - 1 && sy - 1 > 0) {
			pts[3] = new Point(sx, sy - 1);
		}

		if (sx - 1 >= 1 && sx - 1 <= 17) {
			if (rowMap.get(sx - 1) > rowMap.get(sx)) {
				if (sx - 1 > 0 && sy + 1 + ddy <= rowMap.get(sx - 1)) {
					pts[4] = new Point(sx - 1, sy + ddy);
				}
				if (sy + 1 > 0 && sy + 1 + ddy <= rowMap.get(sx - 1)) {
					pts[5] = new Point(sx - 1, sy + 1 + ddy);
				}
			} else {
				if (rowMap.get(sx - 1) >= sy - 1 + ty && sy - 1 + ty > 0) {
					pts[4] = new Point(sx - 1, sy - 1 + ty);
				}
				if (rowMap.get(sx - 1) >= sy + ty && sy + ty > 0) {
					pts[5] = new Point(sx - 1, sy + ty);
				}
			}
		}

		return pts;
	}

	private static Point getLeftTop(int sx, int sy) {

		// adjustments. when change from 4 <==> 5, 13<==>14
		int dy = 0;
		int tty = 0;
		if (sx == 4) {
			dy = 4;
		} else if (sx == 13) {
			tty = -4;
		}
		if (sx + 1 >= 1 && sx + 1 <= 17) {
			if (rowMap.get(sx + 1) > rowMap.get(sx)) {
				if (sy + 1 > 0 && sy + 1 <= rowMap.get(sx + 1)) {
					return new Point(sx + 1, sy + 1 + dy);
				}
			} else {
				if (rowMap.get(sx + 1) >= sy + tty && sy + tty > 0) {
					return new Point(sx + 1, sy + tty);
				}

			}
		}
		return null;
	}

	private static Point getRightTop(int sx, int sy) {

		// adjustments. when change from 4 <==> 5, 13<==>14
		int dy = 0;

		int tty = 0;

		if (sx == 4) {
			dy = 4;
		} else if (sx == 13) {
			tty = -4;
		}
		if (sx + 1 >= 1 && sx + 1 <= 17) {
			if (rowMap.get(sx + 1) > rowMap.get(sx)) {

				if (0 < sx + 1 && sx + 1 <= rowMap.get(sx + 1)) {
					return new Point(sx + 1, sy + dy);
				}
			} else {

				if (rowMap.get(sx + 1) >= sy - 1 + tty && sy - 1 + tty > 0) {
					return new Point(sx + 1, sy - 1 + tty);
				}
			}
		}
		return null;
	}

	private static Point getRightBottom(int sx, int sy) {
		// adjustments. when change from 4 <==> 5, 13<==>14

		int ty = 0;

		int ddy = 0;

		if (sx == 5) {
			ty = -4;
		}

		else if (sx == 14) {
			ddy = 4;
		}
		if (sx - 1 >= 1 && sx - 1 <= 17) {
			if (rowMap.get(sx - 1) > rowMap.get(sx)) {
				if (sx - 1 > 0 && sy + 1 + ddy <= rowMap.get(sx - 1)) {
					return new Point(sx - 1, sy + ddy);
				}

			} else {
				if (rowMap.get(sx - 1) >= sy - 1 + ty && sy - 1 + ty > 0) {
					return new Point(sx - 1, sy - 1 + ty);
				}
			}
		}
		return null;
	}

	private static Point getLeftBottom(int sx, int sy) {

		// adjustments. when change from 4 <==> 5, 13<==>14

		int ty = 0;
		int ddy = 0;

		if (sx == 5) {
			ty = -4;
		} else if (sx == 14) {
			ddy = 4;
		}
		if (sx - 1 >= 1 && sx - 1 <= 17) {
			if (rowMap.get(sx - 1) > rowMap.get(sx)) {

				if (sy + 1 > 0 && sy + 1 + ddy <= rowMap.get(sx - 1)) {
					return new Point(sx - 1, sy + 1 + ddy);
				}
			} else {

				if (rowMap.get(sx - 1) >= sy + ty && sy + ty > 0) {
					return new Point(sx - 1, sy + ty);
				}
			}
		}
		return null;
	}

}

class Point {

	int x;
	int y;

	public Point(int x, int y) {
		super();
		this.x = x;
		this.y = y;
	}

	public String getDivId() {
		return "#" + String.valueOf(x) + "_" + String.valueOf(y);
	}

	public String getIndex() {
		return String.valueOf(x) + "_" + String.valueOf(y);
	}

	@Override
	public String toString() {
		return "Point [x=" + x + ", y=" + y + "]";
	}

}

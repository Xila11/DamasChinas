
<html>
<title>Damas China - History</title>
<head>

 <script type="text/javascript" src="resources/js/sockjs-0.3.min.js"></script>
 <script type="text/javascript" src="resources/js/stomp.js"></script>
 <script type="text/javascript" src="resources/js/jquery-3.1.1.min.js"></script>
 <script type="text/javascript" src="resources/js/jquery.confirm.js"></script>
 
<script>
		var rotNum = 0;
		$(document).ready(function() {				
			/* if ("WebSocket" in window) {
				  var ws = new SockJS('http://localhost:8080/DamasChinas/greeting');
				  ws.onopen = function() {
				    // Web Socket is connected. You can send data by send() method.
				    ws.send("another msg"); 
				  };
				   ws.onmessage = function (evt) { var received_msg = evt.data;
				    alert("Here it is.");
				  	alert(received_msg);
				  }; 	
				  ws.onclose = function() {  
				  };
				 }
				else {
				
					 alert("No support.");
				}  */			
			$.ajax({
				type : "POST",				
				url : "getHistoryGame",
				dataType : 'json',
				data: {userName : $('#jsonBom').val()},
				timeout : 100000,
				success : function(data) {
					console.log("SUCCESS: ", data);
					$.each(data.balls, function(i, item) {
							$(item.index).css('background-color', item.color);					
						});
					
					$('[class^="circle"]').each(function(index){
						$(this).off('click');
					});
				},
				error : function(e) {
					console.log("ERROR: ", e);
				},
				done : function(e) {
					console.log("DONE");
				}
			});
		});
		
		$(document).ready(function() {
			$("#rotate").click(function() {
				if(rotNum == 0)
				{
					$('#board').css(
							"transform","rotate(180deg)");
					rotNum = 1;	
				}
				else
				{
					$('#board').css(
							"transform","rotate(0deg)");
					rotNum = 0;						
					}
				
			});
		});

	
		
</script>
<style>
.row {
	text-align: center;
	width: 100vw;
	justify-content: center;
	display: flex;
	-webkit-appearance: none;
    -webkit-opacity:1
}

.circle {
	height: 40px;
	width: 40px;
	border-radius: 50%;
	border: 2px solid black;
	margin: 8px 8px;
	z-index: 1;
	background-color: white;
	position: relative;
	-webkit-appearance: none;
    -webkit-opacity:1
}

.circleA {
	height: 40px;
	width: 40px;
	border-radius: 50%;
	border: 2px solid black;
	margin: 8px 8px;
	z-index: 1;
	background-color: darkgray;
	position: relative;
	-webkit-appearance: none;
    -webkit-opacity:1
}

.circleAS {
	height: 40px;
	width: 40px;
	border-radius: 50%;
	border: 2px solid black;
	margin: 8px 8px;
	z-index: 1;
	background-color: darkgray;
	position: relative;
	-webkit-appearance: none;
    -webkit-opacity:1
}

.circleBS {
	height: 40px;
	width: 40px;
	border-radius: 50%;
	border: 2px solid black;
	margin: 8px 8px;
	z-index: 1;
	background-color: darkgray;
	position: relative;
	-webkit-appearance: none;
    -webkit-opacity:1
}

.wrapper {

}

 	   .left,
      .right{
        width:0px;
        height: 80px;
        border: 2px solid black;
        position: absolute;
        z-index: -1;
      }
	  
      .cornerleft,
      .cornerright{
        width:0px;
        height: 65px;
        border: 2px solid black;
        position: absolute;
        z-index: -1;
      }

      .cornerleft {
        transform: rotate(28deg);
        margin-left: 17px;
        margin-top: 10px;
      }

      .cornerright{
        transform: rotate(150deg);
        margin-left: 40px;
        margin-top: 20px;
      }

      .right {
        transform: rotate(90deg);
        margin-left: 50px;
        margin-top: -13px;
      }

      .left {
        transform: rotate(270deg);
        margin-left: -15px;
        margin-top: -5px;
      }
</style>
<link rel="icon" 
     type="image/png" 
     href="icon/logo.png"/>
</head>
<body>

	<div class="row" id="rot">
	<input type="hidden" id="jsonBom" value='${userName}'/>
    <div id="rotate">       
		<button type="button">Rotate</button>
	</div>	
	</div>
	<div id="board">
	<div class="row" id="1">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="1_1" class="circleAS"></div>
		</div>
	</div>
	<div class="row" id="2">
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="right"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="2_1" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div id="2_2" class="circleAS"></div>
		</div>
	</div>
	<div class="row" id="3">
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="3_1" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right"></div>
			<div id="3_2" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div id="3_3" class="circleAS"></div>
		</div>
	</div>
	<div class="row" id="4">
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="4_1" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right"></div>
			<div id="4_2" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right"></div>
			<div id="4_3" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div id="4_4" class="circleAS"></div>
		</div>
	</div>
	<div class="row" id="5">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div id="5_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_3" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_4" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_5" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div id="5_6" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_7" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_8" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_9" class="circleAS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_11" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="5_12" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="5_13" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="6">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="6_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_3" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_4" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="6_9" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="6_11" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="6_12" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="7">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="7_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_3" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_4" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="7_9" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="7_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="7_11" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="8">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="8_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_3" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_4" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="8_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="8_9" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="8_10" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="9">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="9_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_2" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_3" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_4" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="9_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div id="9_9" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="10">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="10_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_3" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_4" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="10_9" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div id="10_10" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="11">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="11_3" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_4" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_9" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="11_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div id="11_11" class="circleA"></div>
		</div>

	</div>
	<div class="row" id="12">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_3" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="12_4" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_5" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_6" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_7" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_9" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="12_11" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div id="12_12" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="13">
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_2" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_3" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_4" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_5" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_6" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_7" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_8" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_9" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_11" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div id="13_12" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div id="13_13" class="circleA"></div>
		</div>
	</div>
	<div class="row" id="14">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="14_1" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="14_2" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="14_3" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="14_4" class="circleBS"></div>
		</div>
	</div>
	<div class="row" id="15">

		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="15_1" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div id="15_2" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="15_3" class="circleBS"></div>
		</div>

	</div>
	<div class="row" id="16">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div id="16_1" class="circleBS"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div id="16_2" class="circleBS"></div>
		</div>
	</div>
	<div class="row" id="17">
		<div id="17_1" class="circleBS"></div>
	</div>
	</div>
</body>
</html>

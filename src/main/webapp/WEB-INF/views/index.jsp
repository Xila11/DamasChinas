<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<title>Damas China</title>
<head>
 <link rel="stylesheet" type="text/css" href="resources/css/jquery.confirm.css" />

 <script type="text/javascript" src="resources/js/sockjs-0.3.min.js"></script>
 <script type="text/javascript" src="resources/js/stomp.js"></script>
 <script type="text/javascript" src="resources/js/jquery-3.1.1.min.js"></script>
 <script type="text/javascript" src="resources/js/jquery.confirm.js"></script>
 
 
 
<script>
	
	
    var colWhite = "#6_5,#6_6,#6_7,#6_8"
	+ "#7_4,#7_5,#7_6,#7_7,#7_8"
	+ "#8_3,#8_4,#8_5,#8_6,#8_7,#8_8"
	+ "#9_2,#9_3,#9_4,#9_5,#9_6,#9_7,#9_8"
	+ "#10_3,#10_4,#10_5,#10_6,#10_7,#10_8"
	+ "#11_4,#11_5,#11_6,#11_7,#11_8"
	+"#12_5,#12_6,#12_7,#12_8";
	
	//Create stomp client over sockJS protocol
	var socket = new SockJS("/DamasChinas/ws");
	var stompClient = Stomp.over(socket);
	
	


    // Callback function to be called when stomp client could not connect to server
    var errorCallback = function(error) {
      alert(error.headers.message);
    };

    // Render price data from server into HTML, registered as callback
    // when subscribing to price topic
    function renderPrice(frame) {
    	var username="<%=session.getAttribute("username")%>";
    	 var data = JSON.parse(frame.body);	  
    	 $.each(data.balls, function(i, item) {
			$(item.index).css('background-color', item.color);					
		 }); 
		 if (data.turn == username) {					
			 $("#S1").css(
						'background-color',
				"chartreuse");
				$("#S2").css(
						'background-color',
				"black");
			$("input[type=button]").attr("disabled", false);
			$.each(data.balls, function(i, item) {				
			    if(data.fColor != null && (item.color == "red" || item.color == "blue"))
			    {
					if(data.fUser != username && 
							data.fColor == item.color)
					{
							$(item.index).attr("disabled", true);	
					}
					else if(data.fUser == username && data.fColor != item.color)
					{
						$(item.index).attr("disabled", true);	
					}
			  	}
				
			 });
		} else {
			$("#S1").css(
					'background-color',
			"black");
			$("#S2").css(
					'background-color',
			"OrangeRed");
			$("input[type=button]").attr("disabled", true);
			
		} 
/* 		//reset paras.
			colorPickUp = null;
			pickUp = null;
			colorA = null;
			className=null;	 */
    }
	
    // Register handler for add button
    $(document).ready(function() {
      $('.add').click(function(e){
        e.preventDefault();
        var code = $('.new .code').val();
        var price = Number($('.new .price').val());
        var jsonstr = JSON.stringify({ 'code': code, 'price': price });
        stompClient.send("/app/addStock", {}, jsonstr);
        return false;
      });
    });
    
    // Register handler for remove all button
    $(document).ready(function() {
      $('.remove-all').click(function(e) {
        e.preventDefault();
        stompClient.send("/app/removeAllStocks");
        return false;
      });
    });
    
	var colorPickUp;
	var colorA;
	var className;
	var pickUp;

	 $(document)
			.ready(
					function() {

						$('[class^="circle"]')
								.click(
										function() {
											className = $(this).attr('class');
											
											if(pickUp == null)
										    {
													pickUp =  $(this).attr('id');												
										    }											
											
											colorA = $(this).css(
													"background-color")

											if (colorPickUp == null
													&& colorA.indexOf("0") != -1) {
												colorPickUp = $(this).css(
														"background-color");
												if (className == "circleAS"
														|| className == "circleBS"
														|| className == "circleA"
															|| className == "circle") {
													$(this).css(
															'background-color',
															"darkgray");

												} else {
													$(this).css(
															'background-color',
															"white");
												}

											} else {
												
												if(pickUp != $(this).attr('id'))
												{
													var user = $('#usersId').val();
													 $.ajax({
														type : "POST",													
														url : "move",
														data: {deSelect : pickUp , select : $(this).attr('id'),color:colorPickUp, userName : user},
														dataType : 'json',
														timeout : 100000,
														success : function(data) {
															if(data.valid == false)
															{
																$.confirm({
																	'title'		: '<div style="color:#d81e34">Movement Error</div>',
																	'message'	: 'Invalid movement.<b> Please check it again.</b>',
																	'buttons'	: {
																		'Yes'	: {
																			'class'	: 'red',
																			'action': function(){							
																			}
																		}
																	}
																});	
																
															}
															else
															{
																$(this).css('background-color',
																		colorPickUp);	
																$("input[type=button]").attr("disabled", true);
																$("#S1").css(
																		'background-color',
																"black");
																$("#S2").css(
																		'background-color',
																"red");
																
															}
															console.log("SUCCESS: ", data);
															 $.each(data.balls, function(i, item) {
																$(item.index).css('background-color', item.color);																
															 });
	 
														},
														error : function(e) {
															console.log("ERROR: ", e);
														},
														done : function(e) {
															console.log("DONE");
														}
													}); 													
													
												}
												else
												{
													$(this).css('background-color',
															colorPickUp);														
												}
												
												//reset paras.
												colorPickUp = null;
												pickUp = null;
												colorA = null;
												className=null;																						
												
											}
										});
					}); 

	 $(document).ready(function() {
		$("#start").click(function() {
			var user = $('#usersId').val();
			var username="<%=session.getAttribute("username")%>";
			if(user != username)
			{
				$.confirm({
				'title'		: 'Start Confirmation',
				'message'	: 'Are you sure you want to start a game with<b> '+user+'</b> ?',
				'buttons'	: {
					'Yes'	: {
						'class'	: 'blue',
						'action': function(){
							$.ajax({
								type : "POST",								
								url : "startGame",
								data: {userName : user},
								dataType : 'json',
								timeout : 100000,
								success : function(data) {									
									 console.log("SUCCESS: ", data);									 
									 // Connect to server via websocket									
									 stompClient.connect("guest", "guest", stompClient.subscribe('/topic/'+data.gameId, renderPrice), errorCallback);
									
									 $('[class^="circle"]')
										.each(
												function() {
													var point = $(this).attr('id');													
													if(colWhite.indexOf('#'+point) != -1)
													{
														$('#'+point).css('background-color',"white");				
													}
													else
													{														
														$('#'+point).css('background-color',"darkgray");														
													}
												});
												
									 
									 $.each(data.balls, function(i, item) {
											$(item.index).css('background-color', item.color);					
										}); 
									 if (data.turn == username) {						
										$("#S1").css(
												'background-color',
										"chartreuse ");
										$("#S2").css(
												'background-color',
										"black");
										$("input[type=button]").attr("disabled", false);
										
										$.each(data.balls, function(i, item) {											
										    if(data.fColor != null && 
										    		(item.color == "red" || item.color == "blue"))
										    {
												if(data.fUser != username && 
														data.fColor == item.color)
												{
														$(item.index).attr("disabled", true);	
												}
												else if(data.fUser == username && data.fColor != item.color)
												{
													$(item.index).attr("disabled", true);	
												}
										  	}
											
										 });
									} else {
										$("#S1").css(
												'background-color',
										"black");
										$("#S2").css(
												'background-color',
										"OrangeRed");
										$("input[type=button]").attr("disabled", true);
									} 
									

								},
								error : function(e) {
									console.log("ERROR: ", e);
								},
								done : function(e) {
									console.log("DONE");
								}
							});
						}
					},
					'No'	: {
						'class'	: 'gray',
						'action': function(){}	// Nothing to do in this case. You can as well omit the action property.
					}
				}
			});	
		}
		else
		{
			$.confirm({
				'title'		: 'Start Warning',
				'message'	: 'You can not play with yourself.<b> Please select another user.</b>',
				'buttons'	: {
					'Yes'	: {
						'class'	: 'blue',
						'action': function(){							
						}
					}
				}
			});	
		}
		});
	}); 
	 
	 $(document).ready(function() {
			$("#reset").click(function() {
				var user = $('#usersId').val();
				var username="<%=session.getAttribute("username")%>";
				if(user != username)
				{
					$.confirm({
					'title'		: 'Reset Confirmation',
					'message'	: 'Are you sure you want to reset this game with<b> '+user+'</b> ?',
					'buttons'	: {
						'Yes'	: {
							'class'	: 'blue',
							'action': function(){
								$.ajax({
									type : "POST",				
									url : "removeFile",
									dataType : 'json',
									data: {userName : user},
									timeout : 100000,
									success : function(data) {
										console.log("SUCCESS: ", data);	
										location.reload();
									},
									error : function(e) {
										console.log("ERROR: ", e);
									},
									done : function(e) {
										console.log("DONE");
									}
								});
							}
						},
						'No'	: {
							'class'	: 'gray',
							'action': function(){}	// Nothing to do in this case. You can as well omit the action property.
						}
					}
				});	
			}
			else
			{
				$.confirm({
					'title'		: 'Start Warning',
					'message'	: 'You can not reset game with yourself.<b> Please select another user.</b>',
					'buttons'	: {
						'Yes'	: {
							'class'	: 'blue',
							'action': function(){							
							}
						}
					}
				});	
			}
			});
		}); 
	
	/* $(document).ready(function() {
		var user = $('#usersId').val();		
		$("#reset").click(function() {
			$.ajax({
				type : "POST",				
				url : "removeFile",
				dataType : 'json',
				data: {userName : user},
				timeout : 100000,
				success : function(data) {
					console.log("SUCCESS: ", data);	
					location.reload();
				},
				error : function(e) {
					console.log("ERROR: ", e);
				},
				done : function(e) {
					console.log("DONE");
				}
			});
		});
	}); */
	
	var rotNum = 0;
	
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
	
	$(document).ready(function() {
		
		$("#historyId").click(function() {
			var user = $('#usersId').val();			
			window.open('history?userName=' + user);
			
		});
	});

</script>
<style>
.row {	
	justify-content: center;
	display: flex;
    -webkit-appearance: none;
    -webkit-opacity:1
}

.rowA {	
	
	justify-content: space-around;
	display: flex;
   -webkit-appearance: none;
   -webkit-opacity:1
}
.rowB {	
	
	justify-content: flex-end;
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

.circleSS {
	height: 60px;
	width: 60px;
	border-radius: 50%;
	border: 2px solid black;
	margin: 8px 8px;
	z-index: 1;
	background-color: black;
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
     href="resources/icon/logo.png"/>
</head>
<body>	
    <table style="border:2px solid gray">
    <tr style="border:2px solid gray">
    <td style="border-bottom:2px solid gray">
	<div class="rowA">
	<div id="reset">
		<button type="button">Reset</button>		
	</div>		
	<div id="user">
		<form:select id="usersId" path="users" items="${users}">  
        </form:select>
	</div>	
	<div id="start">
		<button type="button">Start</button>
	</div>
	<div id="rotate">
		<button type="button">Rotate</button>
	</div>
	<div id="history">		
		 	<button type="button" id="historyId">History</button>		
	</div>	
	<div id="logout">
		 	<button type="submit" id="logoutId" onclick="location.href = 'logout'">out</button>
	</div>	
	<div id="who">
		 	<button type="button" disabled >${username}</button>
	</div>	
	<div><p id="preview"></p></div>
	</div>
	</td>
	</tr>
	<tr style="border:2px solid gray">
	<td>
	<div id="board">
	<div class="row" id="1">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="1_1" class="circleAS"/></div>
		</div>
	</div>
	<div class="row" id="2">
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="right"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="2_1" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div><input type="button"  id="2_2" class="circleAS"/></div>
		</div>
	</div>
	<div class="row" id="3">
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="3_1" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right"></div>
			<div><input type="button"  id="3_2" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div><input type="button"  id="3_3" class="circleAS"/></div>
		</div>
	</div>
	<div class="row" id="4">
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="4_1" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right"></div>
			<div><input type="button"  id="4_2" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right"></div>
			<div><input type="button"  id="4_3" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div><input type="button"  id="4_4" class="circleAS"/></div>
		</div>
	</div>
	<div class="row" id="5">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div><input type="button"  id="5_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_3" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_4" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_5" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div><input type="button"  id="5_6" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_7" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_8" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_9" class="circleAS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_10" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_11" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright"></div>
			<div class="cornerleft"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_12" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="5_13" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="6">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_3" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_4" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_8" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_9" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="6_10" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
		    <div><input type="button"  id="6_11" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="6_12" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="7">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_1" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_3" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_4" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_8" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_9" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="7_10" class="circleA"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="7_11" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="8">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_3" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_4" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_8" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="8_9" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="8_10" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="9">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_2" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_3" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_4" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="9_8" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div><input type="button"  id="9_9" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="10">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_3" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_4" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_8" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="10_9" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div><input type="button"  id="10_10" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="11">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_3" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_4" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_8" class="circle"></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_9" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="11_10" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div><input type="button"  id="11_11" class="circleA"/></div>
		</div>

	</div>
	<div class="row" id="12">
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_3" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_4" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_5" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_6" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_7" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_8" class="circle"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_9" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_10" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="12_11" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div><input type="button"  id="12_12" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="13">
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_1" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_2" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_3" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_4" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_5" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_6" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_7" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_8" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_9" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_10" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_11" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div class="right" style="border: 4px solid black;"></div>
			<div><input type="button"  id="13_12" class="circleA"/></div>
		</div>
		<div class="wrapper">
			<div><input type="button"  id="13_13" class="circleA"/></div>
		</div>
	</div>
	<div class="row" id="14">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="14_1" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="14_2" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="14_3" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button" id="14_4" class="circleBS"/></div>
		</div>
	</div>
	<div class="row" id="15">

		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="15_1" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft"></div>
			<div class="cornerright"></div>
			<div class="right"></div>
			<div><input type="button"  id="15_2" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="15_3" class="circleBS"/></div>
		</div>

	</div>
	<div class="row" id="16">
		<div class="wrapper">
			<div class="cornerright" style="border: 4px solid black;"></div>
			<div class="right"></div>
			<div><input type="button"  id="16_1" class="circleBS"/></div>
		</div>
		<div class="wrapper">
			<div class="cornerleft" style="border: 4px solid black;"></div>
			<div><input type="button"  id="16_2" class="circleBS"/></div>
		</div>
	</div>
	<div class="row" id="17">
		<div><input type="button" id="17_1" class="circleBS"/></div>
	</div>
	</div>
	<td>
	<td style="border-left:2px solid gray;">
	<div class="wrapper">			
			<div><input type="button"  id="S1" class="circleSS"/></div>
		</div>
		<div class="wrapper">			
			<div><input type="button"  id="S2" class="circleSS"/></div>
		</div>
	</td >
	</tr>	
	<tr>
	
	<td style="border-top:2px solid gray;">	
	<div class="rowB">
	 <b>Copyright © 2016</b>
	 </div>
	<div class="rowB">
	 <b>Developed by : Dilan Weerasinghe</b>
	 </div>
	 <div class="rowB">
	 <b>Release 1.0.5</b>
	 </div>
	</td>
	</tr>
	</table>
</body>
</html>

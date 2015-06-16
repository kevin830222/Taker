<!DOCTYPE html>
<html lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<style ="text="" css"="">
	/*
	a.button{
    height: 40px;
    background-image:url("http://img.techxplore.com/newman/gfx/news/hires/2013/facebook_like_thumb.jpg");
    text-indent: -9999px;
    display:inline-block;}
    
    a#aaa{
    width:40px;
    background-position: 0px 0px;} */
    ul.enlarge{
        list-style-type:none; /*remove the bullet point*/
    }
    ul.enlarge li{
        display:inline-block; /*places the images in a line*/
        position: relative; /*allows precise positioning of the popup image when used with position:absolute - see support section */
        z-index: 0; /*resets the stack order of the list items - we'll increase in step 4. See support section for more info*/
        margin:10px 40px 0 20px; /*space between the images*/
    }
    ul.enlarge span{
        position:absolute; /*see support section for more info on positioning*/
        left: -9999px; /*moves the span off the page, effectively hidding it from view*/
    }
    ul.enlarge img{
    /*give the thumbnails a frame*/
        background-color:#eae9d4; /*frame colour*/
        padding: 6px; /*frame size*/
        /*add a drop shadow to the frame*/
        -webkit-box-shadow: 0 0 6px rgba(132, 132, 132, .75);
        -moz-box-shadow: 0 0 6px rgba(132, 132, 132, .75);
        box-shadow: 0 0 6px rgba(132, 132, 132, .75);
        /*and give the corners a small curve*/
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
    }
    ul.enlarge span{
        position:absolute;
        left: -9999px;
        background-color:#eae9d4;
        padding: 10px;
        font-family: 'Droid Sans', sans-serif;
        font-size:.9em;
        text-align: center; 
        color: #495a62; 
        -webkit-box-shadow: 0 0 20px rgba(0,0,0, .75));
        -moz-box-shadow: 0 0 20px rgba(0,0,0, .75);
        box-shadow: 0 0 20px rgba(0,0,0, .75);
        -webkit-border-radius: 8px; 
        -moz-border-radius: 8px; 
        border-radius:8px;
    }
    ul.enlarge li:hover{
        z-index: 50;
        cursor:pointer;
    }
    ul.enlarge span img{
        padding:2px;
        background:#ccc;
    }
    ul.enlarge li:hover span{ 
        top: -300px; /*the distance from the bottom of the thumbnail to the top of the popup image*/
        left: -20px; /*distance from the left of the thumbnail to the left of the popup image*/
    }
    ul.enlarge li:hover:nth-child(2) span{
      left: -100px; 
    }
    ul.enlarge li:hover:nth-child(3) span{
       left: -200px; 
    }
    /***Override the styling of images set in step 3 to make the frame smaller and the background darker***/
    ul.enlarge span img{
        padding: 2px; /*size of the frame*/
        background: #ccc; /*colour of the frame*/
    }
    /***Style the <span> containing the framed images and the caption***/
    ul.enlarge span{
        /**Style the frame**/
        padding: 10px; /*size of the frame*/
        background:#eae9d4; /*colour of the frame*/
        /*add a drop shadow to the frame*/
        -webkit-box-shadow: 0 0 20px rgba(0,0,0, .75));
        -moz-box-shadow: 0 0 20px rgba(0,0,0, .75);
        box-shadow: 0 0 20px rgba(0,0,0, .75);
        /*give the corners a curve*/
        -webkit-border-radius: 8px;
        -moz-border-radius: 8px;
        border-radius:8px;
        /**Style the caption**/
        font-family: 'Droid Sans', sans-serif; /*Droid Sans is available from Google fonts*/
        font-size:.9em;
        text-align: center;
        color: #495a62;
    }
    </style>
    
    
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>FaceMe -- welcome page</title>

    <!-- Bootstrap Core CSS -->
    <link href="index_files/bootstrap.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="index_files/grayscale.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="index_files/font-awesome.css" rel="stylesheet" type="text/css">
    <link href="index_files/css.css" rel="stylesheet" type="text/css">
    <link href="index_files/css_002.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

<script style="" src="index_files/common.js" charset="UTF-8" type="text/javascript"></script><script src="index_files/util.js" charset="UTF-8" type="text/javascript"></script><script src="index_files/stats.js" charset="UTF-8" type="text/javascript"></script>

    <!--ajax-->
    <script>
    function loadXMLDoc()
    {
    var xmlhttp;
    if (window.XMLHttpRequest)
      {// code for IE7+, Firefox, Chrome, Opera, Safari
      xmlhttp=new XMLHttpRequest();
      }
      else
      {// code for IE6, IE5
      xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
      }

    xmlhttp.onreadystatechange=function()
      {
      if (xmlhttp.readyState==4 && xmlhttp.status==200)
        {
        document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
        }
      }
    xmlhttp.open("GET","ajax_info.txt",true);
    xmlhttp.send();
    }
    </script>




</head>

<body id="page-top" data-spy="scroll" data-target=".navbar-fixed-top">



    <!-- Navigation -->
    <nav class="navbar navbar-custom navbar-fixed-top" role="navigation">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse"><em class="fa fa-bars"></em></button>
                <a class="navbar-brand page-scroll" href="#page-top">
                    <i class="fa fa-play-circle"></i>  <span class="light"><img src="index_files/fb_icon_325x325.png" height="40px" width="40px"></span>
                </a>
            </div>

            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse navbar-right navbar-main-collapse">
                <ul class="nav navbar-nav">
                    <!-- Hidden li included to remove active class from about link when scrolled up past about section -->
                    <li class="hidden active">
                        <a href="#page-top"></a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#about">About FaceMe</a>
                    </li>
                    <li>
                        <a class="page-scroll" href="#contact">Contact</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>


    <p id="demo"></p>

    <script>
    var cars = ["Saab", "Volvo", "BMW"];
    document.getElementById("demo").innerHTML = cars[0];
    </script>


    <!-- Intro Header -->
    <header class="intro">
        <div class="intro-body">
            <div class="container">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <h1>FaceMe</h1>
                        <!--<p class="intro-text">A free, responsive, one page Bootstrap theme.<br>Created by Start Bootstrap.<br>-->
                     
                        <ul class="enlarge">
                        <li>
<img src="index_files/fb_icon_325x325.png" height="100px" width="100px"> <!--thumbnail image-->
<span> <!--span contains the popup image-->
<img src="index_files/fb_icon_325x325.png"> <!--popup image-->
<!--caption appears under the popup image-->
</span>
</li>
<li>
<img src="index_files/fb_icon_325x325.png" height="100px" width="100px"> <!--thumbnail image-->
<span> <!--span contains the popup image-->
<img src="index_files/fb_icon_325x325.png"> <!--popup image-->
<!--caption appears under the popup image-->
</span>
</li>
<li>
<img src="index_files/fb_icon_325x325.png" height="100px" width="100px"> <!--thumbnail image-->
<span> <!--span contains the popup image-->
<img src="index_files/fb_icon_325x325.png"> <!--popup image-->
<!--caption appears under the popup image-->
</span>
</li>
</ul>                                           
                        <a href="#about" class="btn btn-circle page-scroll">
                            <i class="fa fa-angle-double-down animated"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </header>

<div id="myDiv"><h2>Let AJAX change this text</h2></div>
<button type="button" onclick="loadXMLDoc()">Change Content</button>


    <!-- About Section -->
    <section id="about" class="container content-section text-center">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <h2>About Faceme</h2>
                <p></p><div align="center">
                    <dl>
                    <dt><font size="4">● Another Way For “Draw Something”</font>
                    </dt><dt><font size="4">● Combination With Social Network</font>
                    </dt><dt><font size="4">● More Interesting And Addicted</font> 
                    </dt></dl>
                    </div>
                <p></p>
                <h3>Tech applied</h3>
                <p></p><div align="center">
					<dl>
                    <dt><font size="4">● Social Networking: Facebook Based</font>
                    </dt><dt><font size="4">● Backend: Database / Notification</font>
                    </dt><dt><font size="4">● Frontend: Website / APP</font>
                    </dt></dl> 
                    </div>               
                <p></p>
            </div>
        </div>
    </section>

    <!-- Download Section
    <section id="download" class="content-section text-center">
        <div class="download-section">
            <div class="container">
                <div class="col-lg-8 col-lg-offset-2">
                    <h2>Download Grayscale</h2>
                    <p>You can download Grayscale for free on the preview page at Start Bootstrap.</p>
                    <a href="http://startbootstrap.com/template-overviews/grayscale/" class="btn btn-default btn-lg">Visit Download Page</a>
                </div>
            </div>
        </div>
    </section> -->

    <!-- Contact Section -->
    <section id="contact" class="container content-section text-center">
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2">
                <h2>Contact Faceme</h2>
                <p></p><div align="center"><font size="4">Feel free to email us to provide some feedback on our <br>templates, give us suggestions or just say hello!</font></div><p></p>
                <p><a href="mailto:b01902087@ntu.edu.tw">b01902087@ntu.edu.tw</a>
                </p>
                <ul class="list-inline banner-social-buttons">
                    <li>
                        <a href="https://www.facebook.com/kevin830222" class="btn btn-default btn-lg"><span class="network-name"><i class="fa fa-facebook fa-fw"></i> CEO -- 徐愷</span></a>
                    </li>
                    <li>
                        <a href="" class="btn btn-default btn-lg"><i class="fa fa-facebook fa-fw"></i> <span class="network-name">FaceMe -- club</span></a>
                    </li>
                </ul>
            </div>
        </div>
    </section>

    <!-- Map Section 
    <div id="map"></div>-->

    <!-- Footer -->
    <footer>
        <div class="container text-center">
            <p>Copyright © FaceMe 2015</p>
        </div>
    </footer>

    <!-- jQuery -->
    <script src="index_files/jquery_002.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="index_files/bootstrap.js"></script>

    <!-- Plugin JavaScript -->
    <script src="index_files/jquery.js"></script>

    <!-- Google Maps API Key - Use your own API key to enable the map feature. More information on the Google Maps API can be found at https://developers.google.com/maps/ -->
    <script type="text/javascript" src="index_files/js"></script><script src="index_files/main.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="index_files/grayscale.js"></script>




</body></html>
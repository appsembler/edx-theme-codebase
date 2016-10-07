$(document).ready(function(){

	// site mobile nav toggle
	$('#site-menu-toggle').on('click', function() {
		$(this).toggleClass('a--toggled');
		$('#slide-menu').toggleClass('a--active');
	});

	// courseware nav toggling
	$('.a--course-content__nav__mobile-toggle').on('click', function() {
		$('.a--course-content__nav__mobile-toggle').slideToggle();
		$('#course-nav-wrapper').slideToggle();
	});

	// execute css on-load animations
	$('.a--animated').addClass("a--do-animate");

	function isScrolledIntoView(elem) {
    var docViewTop = $(window).scrollTop();
    var docViewBottom = docViewTop + $(window).height();

    var elemTop = $(elem).offset().top;
    var elemBottom = elemTop + $(elem).height();

    return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop));
}

	$(window).scroll(function () {
	   $('.a--animate-on-scroll.a--out-animation').each(function () {
	      if (isScrolledIntoView(this) === true) {
	          $(this).addClass('a--in-view');
	      } else {
					$(this).removeClass('a--in-view');
				}
	   });
	});

	$(window).scroll(function () {
	   $('.a--animate-on-scroll.a--no-out-animation').each(function () {
	      if (isScrolledIntoView(this) === true) {
	          $(this).addClass('a--in-view');
	      }
	   });
	});

	$('.a--reveal-on-load').each(function() {
		$(this).addClass('a--revealed');
	});

	$('.a--expanding-section').on('click', function() {
	 $('.a--expanding-section').each((function(index, el) {
		 $(this).removeClass('a--expanded');
			 }));
	 $(this).toggleClass('a--expanded');
 	});

	$("#discovery-expand-button").click(function() {
    $(this).toggleClass("activated");
    $("#discovery-expanding-area").slideToggle();
	})

	// YouTube control
	var tag = document.createElement('script');
	tag.src = "//www.youtube.com/player_api";
	var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
});


// TouTube pausing in modals

function getFrameID(id){
	var elem = document.getElementById(id);
	if (elem) {
			if(/^iframe$/i.test(elem.tagName)) return id; //Frame, OK
			// else: Look for frame
			var elems = elem.getElementsByTagName("iframe");
			if (!elems.length) return null; //No iframe found, FAILURE
			for (var i=0; i<elems.length; i++) {
				 if (/^https?:\/\/(?:www\.)?youtube(?:-nocookie)?\.com(\/|$)/i.test(elems[i].src)) break;
			}
			elem = elems[i]; //The only, or the best iFrame
			if (elem.id) return elem.id; //Existing ID, return it
			// else: Create a new ID
			do { //Keep postfixing `-frame` until the ID is unique
					id += "-frame";
			} while (document.getElementById(id));
			elem.id = id;
			return id;
	}
	// If no element, return null.
	return null;
}

var youTubePlayers = {};

function onYouTubePlayerAPIReady() {
	$(".youtube-modal-iframe[id]").each(function() {
		var identifier = this.id;
		var frameID = getFrameID(identifier);
		if (frameID) {
			youTubePlayers[frameID] = new YT.Player(frameID, {
				events: {
					"onReady": createYTEvent(frameID, identifier)
				}
			});
		}
	});
}


function createYTEvent(frameID, identifier) {
	return function (event) {
		buttonId = "a--video-modal-close-" + frameID;
		var pauseButton = document.getElementById(buttonId);
		pauseButton.addEventListener("click", function() {
			youTubePlayers[frameID].pauseVideo();
		})
	}
}


function toggleCoursewareNavChevrons() {
	var childrenTotalWidth = 0;
	$('#courseware-top-nav-list li').each(function(){
    childrenTotalWidth += $(this).width();
	});
	if ($('#courseware-top-nav-container').width() < childrenTotalWidth) {
		$('#courseware-top-nav-chevron').addClass("visible");
	}
}

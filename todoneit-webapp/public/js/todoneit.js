var ToDoneIt = {
    onLoad: function() {
	ToDoneIt.Menu.onLoad();
    },
    QuickAdd : {
	onLoad: function() {
	    $('#quickadd input:first').click(function() {
		    var element = $(this);
		    if (element.hasClass('helptext')) {
			element.val('');
			element.removeClass('helptext');
		    }
		});
	}
    },
    Menu: {
	onLoad: function() {
	    jQuery.each($('#menu li'), function(element) {
		$(this).hover(function() {
			$(this).addClass('hover');
		    }, function() {
			$(this).removeClass('hover');
		    });
		});
	    $('#menu li.complete a:first').click(function() {
		    ToDoneIt.Menu.completeSelected();
		});
	},
	completeSelected: function() {
	    jQuery.each($('.task.selected'), function(element) {
		    var element = $(this);
		    element.removeClass('incomplete');
		    element.removeClass('selected');
		    element.addClass('complete');
		    ToDoneIt.Timeline.totalSelected --;
		    $('#menu .totalSelected span:first').text(ToDoneIt.Timeline.totalSelected);
		});
	}
    },
    Timeline : {
	requests: 0,
	totalSelected: 0,
	onLoad: function() {
	    var access = 'public';
	    if ($($('body')[0]).hasClass('logged_in')) {
		access = 'private';
	    }
	    ToDoneIt.Timeline.load('#sometime', '/tasks/timeline/' + access +'/sometime');
	    ToDoneIt.Timeline.load('#previously', '/tasks/timeline/' + access + '/previously');
	    ToDoneIt.Timeline.load('#yesterday', '/tasks/timeline/' + access + '/yesterday');
	    ToDoneIt.Timeline.load('#tomorrow', '/tasks/timeline/' + access + '/tomorrow');
	    ToDoneIt.Timeline.load('#today', '/tasks/timeline/' + access + '/today');
	},
	load: function(element, url) {
	    ToDoneIt.Timeline.requests ++;
	    $(element).load(url, null, ToDoneIt.Timeline.callback);
	},
	callback: function(responseText, textStatus, request) {
	    ToDoneIt.Timeline.requests = ToDoneIt.Timeline.requests - 1;
	    if (ToDoneIt.Timeline.requests <= 0) {
		ToDoneIt.Timeline.complete();
	    }
	},
	complete: function() {
	    jQuery.each($('.task-list .expand'), function(element) {
		    $(this).simpletip({content: 'Expand', fixed: false});
		    $(this).click(function() {
			    if ($(this).text() === '+') {
				$(this).text('-');
			    } else {
				$(this).text('+');
			    }
			    $(this).parent().toggleClass('expanded');
			});
		});
	    jQuery.each($('.task'), function(element) {
		    $(this).click(function() {
			    var element = $(this);
			    if (element.hasClass("selected")) {
				ToDoneIt.Timeline.totalSelected --;
			    } else {
				ToDoneIt.Timeline.totalSelected ++;
			    }
			    element.toggleClass('selected');
			    $('#menu .totalSelected span:first').text(ToDoneIt.Timeline.totalSelected);
			    if (ToDoneIt.Timeline.totalSelected > 0) {
				$('#menu').show();
			    } else {
				$('#menu').hide();
			    }	
			});
		});
	}
    }
};

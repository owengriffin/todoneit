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
	    $('#menu li.promote a:first').click(function() {
		    ToDoneIt.Menu.promoteSelected();
		});
	    $('#menu li.relegate a:first').click(function() {
		    ToDoneIt.Menu.relegateSelected();
		});
	},
	completeSelected: function() {
	    jQuery.each($('.task.selected'), function(element) {
		    var task_id = $(this).attr('id').match(/task_(.*)/)[1];
		    $.ajax(
{ 
    type: 'POST',
	dataType: 'json',
	url: '/tasks/' + task_id + '/complete',
	success: function(data) {
	var element = $('#task_' + data.task_id);
	element.removeClass('incomplete');
	element.removeClass('selected');
	element.addClass('complete');
	ToDoneIt.Timeline.totalSelected --;
	$('#menu .totalSelected span:first').text(ToDoneIt.Timeline.totalSelected);	    
    }
});
		});
	},
	promoteOrRelegate: function(type) {
jQuery.each($('.task.selected'), function(element) {
		    var task_id = $(this).attr('id').match(/task_(.*)/)[1];
		    $.ajax(
{ 
    type: 'POST',
	dataType: 'json',
	url: '/tasks/' + task_id + '/' + type,
	success: function(data) {
	var element = $('#task_' + data.task_id);
	element.removeClass('selected');
	element = $('#task_' + data.task_id);
	if (element.hasClass('priority1') && data.priority != 1) {
	    element.removeClass('priority1');
	}
	if (element.hasClass('priority2') && data.priority != 2) {
	    element.removeClass('priority2');
	}
	if (element.hasClass('priority3') && data.priority != 3) {
	    element.removeClass('priority3');
	}
	element.addClass('priority' + data.priority);
	element = $('#task_' + data.task_id + ' .priority');
	element.text(data.priority);
	element.show();
	ToDoneIt.Timeline.totalSelected --;
	$('#menu .totalSelected span:first').text(ToDoneIt.Timeline.totalSelected);	    
    }
});
		});
	},
	promoteSelected: function() {
	    ToDoneIt.Menu.promoteOrRelegate('promote');
	},
	relegateSelected: function() {
	    ToDoneIt.Menu.promoteOrRelegate('relegate');
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

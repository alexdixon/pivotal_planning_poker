$(document).ready(function() {
    function isEmpty(obj) {
        var name;
        for (name in obj) {
            if (obj.hasOwnProperty(name)) {
                return false;
            }
        }
        return true;
    }

    var pivotalEstimateString = function(estimate) {
        if (estimate == '-1') {
            return 'Unestimated';
        } else if (estimate == null) {
            return 'Unestimated';
        } else {
            return estimate;
        }
    };

    var refreshEstimates = function(data) {
        if (data['estimates'][$("#current_username").attr('value')] != null) {
            $("#your_estimate").html('<p id="your_estimate">Your Estimate: ' + data['estimates'][$("#current_username").attr('value')] + '</p>');
        } else {
            $("#your_estimate").html('<p id="your_estimate">You haven\'t placed a bet</p>');
        }

        $("#tracker_estimate").html('<p>This story is estimated as a ' +
                '<span class="large">' +
                pivotalEstimateString(data['tracker_estimate']) +
                '</span> in Pivotal Tracker.</p>');

        $("#estimate").val(data['tracker_estimate']);

        var html = '';
        if (isEmpty(data['estimates'])) {
            html += "<p>No one has estimated this story.</p>"
        } else {
            if (data.revealed) {
                html += '<ul>';
                
                for (var key in data['estimates']) {
                    html += '<li>' + data['estimates'][key] + ' (' + key + ')</li>';
                }

                html += '</ul>';

                html += '<p><a href="#" id="re_estimate_link">Play again?</a>';
            } else {
                var keys = [ ];
                for (key in data['estimates']) {
                    keys.push(key);
                }

                if (keys.length == 1)
                    html += '<p>Bets posted by one person: '
                else
                    html += '<p>Bets posted by ' + keys.length + ' people: ';
                html += keys.join(', ');
                html += '.</p>';

                html += '<p> Bets have not been revealed.  <a href="#" id="reveal_cards_link">Reveal them?</a>';
            }
        }

        $("#estimates").html(html);
        $("#reveal_cards_link").click(function(){
            $.ajax({
                url: $("#reveal_estimate_url").attr('value'),
                data: {'revealed' : true},
                type: 'PUT',
                context: document.body,
                success: function() { }
            });
        });
        $("#re_estimate_link").click(function(){
            $.ajax({
                url: $("#reveal_estimate_url").attr('value'),
                data: {'revealed' : false},
                type: 'PUT',
                context: document.body,
                success: function() { }
            });
        });

        $(".poker_chip").click(function(){
            var estimate = 0;
            for (var i = 0; i < 9; i++) {
                if ($(this).hasClass('val' + i))
                    estimate = i;
            }
            $.ajax({
                url: $('#estimate_url').attr('value'),
                type: 'POST',
                data: {'estimate' : estimate},
                context: document.body,
                success: function() {
                    console.log('posted estimate ' + estimate + ' successfully');
                    $("#your_estimate").html('<p id="your_estimate">Your Estimate: ' + estimate + '</p>');
                }
            });
            return false;
        });
    };

    $.get($('#estimate_url').attr('value'), function(data) {
        refreshEstimates(data);
    });

    $.PeriodicalUpdater($('#estimate_url').attr('value'), {
        method: 'get',
        data: '',                   // array of values to be passed to the page - e.g. {name: "John", greeting: "hello"}
        minTimeout: 2000,           // starting value for the timeout in milliseconds
        maxTimeout: 2000,           // maximum length of time between requests
        multiplier: 2,              // if set to 2, timerInterval will double each time the response hasn't changed (up to maxTimeout)
        type: 'json',               // response type - text, xml, json, etc.  See $.ajax config options
        maxCalls: 0,                // maximum number of calls. 0 = no limit.
        autoStop: 0                 // automatically stop requests after this many returns of the same data. 0 = disabled.
    }, function(data) {
        refreshEstimates(data);
    });
});

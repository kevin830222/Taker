/*
 * Bootstrap Image Gallery JS Demo 3.0.1
 * https://github.com/blueimp/Bootstrap-Image-Gallery
 *
 * Copyright 2013, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

/*jslint unparam: true */
/*global blueimp, $ */

$(function () {
    'use strict';

    var loc = window.location.href;
    var dir = loc.substring(0, loc.lastIndexOf('/')+1);

    // Load problems from server:
    $.ajax({
        url: dir + 'dev/get_problems.php'
    }).done(function (result) {
        var galleryContainer = $('#gallery');
        var res = JSON.parse(result);
        var topics = JSON.parse(res['data']);
        topics.forEach(function(topic, index){
            var name = topic["name"];
            var pictures = topic["pictures"];
            var topicDiv = jQuery('<div/>', {
                id: name + "Div",
                style: "margin-top: 10px; background: ##9FC091",
            })
            .appendTo(galleryContainer);
            topicDiv.append('<p>' + name + '</p>')
            pictures.forEach(function(picture, index){
                var filename = dir + "dev/picture/" + topic["prob_id"] + "/" + picture;
                $('<a/>')
                    .append($('<img>').prop('src', filename).prop('width', '100'))
                    .prop('href', filename)
                    .prop('title', name + " - " + index)
                    .attr('data-gallery', '')
                    .appendTo(topicDiv);
            });

        });
    });

    $('#image-gallery-button').on('click', function (event) {
        event.preventDefault();
        blueimp.Gallery($('#links a'), $('#blueimp-gallery').data());
    });



});

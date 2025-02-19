/*
 * This program is part of the OpenCms Mercury Template.
 *
 * Copyright (c) Alkacon Software GmbH & Co. KG (http://www.alkacon.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Polyfills to support IE 11
import 'promise-polyfill/src/polyfill';
import 'mdn-polyfills/Object.assign';

import jQuery                       from 'jquery';
import bootstrap                    from 'bootstrap';
import jsDevice                     from 'current-device';
import fitVids                      from 'fitvids';
Object.assign(lazySizes.cfg,        { init:false }); // otherwise device based configuration will not work
import lazySizes                    from 'lazysizes';

import * as DynamicListElemements   from './lists.js';
import * as NavigationElements      from './navigation.js';
import * as CommentElements         from './comments.js';
import * as AnalyticElements        from './analytics.js';
import * as PrivacyPolicy           from './privacy-policy.js';

import jQueryExtensions             from './jquery-extensions.js';
import unobfuscateString            from './unobfuscate.js';

import { _OpenCmsReinitEditButtons, _OpenCmsInit } from './opencms-callbacks.js';

// Module implemented using the "revealing module pattern", see
// https://addyosmani.com/resources/essentialjsdesignpatterns/book/#revealingmodulepatternjavascript
// https://www.christianheilmann.com/2007/08/22/again-with-the-module-pattern-reveal-something-to-the-world/
var Mercury = function(jQ) {

    "use strict";

    var VERBOSE = false || (getParameter("jsverbose") != null);
    var DEBUG = VERBOSE || (getParameter("jsdebug") != null);

    // container for information passed from CSS to JavaScript
    var m_info = {};

    // the color theme passed from CSS to JavaScript
    var m_theme = null;

    // the grid size when the page was loaded
    var m_gridInfo = {};

    // the current window
    var m_$window = jQ(window);

    // height of current window
    var m_windowHeight = m_$window.height();

    // width of current window
    var m_windowWidth = m_$window.width();

    // element update callback functions
    var m_updateCallbacks = [];

    // attach event listener to window resize event (debounced)
    m_$window.resize(debounce(function() {
        m_windowHeight = m_$window.height();
        m_windowWidth = m_$window.width();

        if (DEBUG) console.info("Mercury current grid size: " + m_gridInfo.currentSize());
    }, 50));


    function windowHeight() {
        return m_windowHeight;
    }


    function windowWidth() {
        return m_windowWidth;
    }


    function toolbarHeight() {
        return isEditMode() ? 52 : 0;
    }


    function windowScrollTop() {
        return m_$window.scrollTop();
    }


    function device() {
        // returns information about the current device
        // this is provided by the current-device plugin
        return jsDevice;
    }


    function debounce(func, wait, immediate) {
        // debounce function to optimize JavaScript events
        // see https://davidwalsh.name/javascript-debounce-function
        var timeout;
        return function() {
            var context = this, args = arguments;
            var later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = window.setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    }


    function addInfo(info) {

        jQ.extend(m_info, info);

        if (DEBUG) console.info("Mercury info extended to:");
        if (DEBUG) jQ.each(m_info, function( key, value ) { console.info( "- " + key + ": " + value ); });
    }


    function hasInfo(key) {

        return key in m_info;
    }


    function getInfo(key) {

        if ((key in m_info) && (m_info[key] != "none")) {
            return m_info[key];
        }
        return null;
    }


    function getLocale() {

        var locale = getInfo("locale");
        return (typeof locale !== "undefined") ? locale : "en";
    }


    function addContext(path) {

        var contextPath = getInfo("context");
        contextPath = (typeof contextPath !== "undefined") ? contextPath : "/";
        path = path.startsWith("/") ? path.substr(1) : path;
        return contextPath + path;
    }


    function isNotEmpty(string) {
        // checks if the argument variable is of type string and has a length > 0
        var result = false;
        if ((typeof string === "string") && (string.trim().length > 0)) {
           result = true;
        }
        return result;
    }


    function removeQuotes(string) {
        // passing variables from SCSS to JavaScript
        // see https://css-tricks.com/making-sass-talk-to-javascript-with-json/
        if (typeof string === "string" || string instanceof String) {
            string = string.replace(/^['"]+|\\|(;\s?})+|['"]$/g, '');
        }
        return string;
    }


    function parseJson(data) {
        // parses JSON with error handling
        var result = {};
        if (isNotEmpty(data) && (data != "none")) {
            try {
                result = JSON.parse(data);
            } catch (err) {
                console.warn("Error parsing JSON data '" + data + "'", err);
            }
        }
        return result;
    }


    function getParameter(key) {
        key = key.replace(/[*+?^$.\[\]{}()|\\\/]/g, "\\$&"); // escape RegEx meta chars
        var match = location.search.match(new RegExp("[?&]"+key+"=([^&]+)(&|$)"));
        return match && decodeURIComponent(match[1].replace(/\+/g, " "));
    }


    function getCssJsonData(elementId) {
        // reads JSON data from the CSS and returns it as an JS object
        var data = getCssDataFromId(elementId);
        if (DEBUG) console.info("Mercury data found in CSS: [" + data + "]");
        return parseJson(data);
    }


    function getCssDataFromElement(element, after) {
        // read data from ::before or ::after elements in the CSS
        var selector = after ? '::after' : '::before';
        var data = null;
        if (element) {
            if (window.getComputedStyle && window.getComputedStyle(element, selector) ) {
                data = window.getComputedStyle(element, selector);
                data = data.content;
            }
        }
        return data != null ? removeQuotes(data) : data;
    }


    function getCssDataFromId(elementId, after) {
        var element = document.getElementById(elementId);
        var data = getCssDataFromElement(element, after);
        return data;
    }


    function getCssDataFromJQuery($element, after) {
        var element = $element.get(0);
        return getCssDataFromElement(element, after);
    }


    function initInfo() {
        // the CSS template stores JSON encoded information for the JavaScript
        // in the HTML elements with the ID #template-info
        // initialize info sections with values from data attributes
        jQ('#template-info').each(function() {
            var $element = jQ(this);
            if (typeof $element.data("info") !== "undefined") {
                var $info = $element.data("info");
                addInfo($info);
            }
            m_theme = getCssJsonData($element.attr('id'));
            if (DEBUG) console.info("Mercury theme JSON: " + getThemeJSON("main-theme", []));
        });

        initGridInfo();
    }


    function getThemeJSON(key, defaultValue) {
        // the CSS template theme stores several values in the CSS by JSON
        // these values are returned by this function
        // this way it is possible to pass information from the CSS to the JavaScript
        // currently the CSS theme provides the following information:
        // * color information (main theme colors, background colors, map marker colors...)
        // * information about the grid size (responsive breakpoints, points where the mobile nav appears)
        // * header information (stick header enabled or disabled) - note that the JS can overwrite this
        // * ...other stuff
        var result = defaultValue; // default return color when all else fails
        if (m_theme) {
            try {
                var col = Object.byString(m_theme, key);
                if (typeof col !== "undefined") {
                    result = col;
                }
            } catch (e) {
                // result will be default
            }
        }

        return result;
    }


    function isOnlineProject() {
        // returns if the current OpenCms project is the online project
        // this information about is directly rendered into the template by OpenCms when the page is created
        // it is stored in the #template-info HTML element
        return ("online" == m_info["project"]);
    }


    function isEditMode() {
        // returns "true" if OpenCms runs in edit mode
        // this means the "offline" project is selected AND the edit buttons are enabled in ADE
        // this information about is directly rendered into the template by OpenCms when the page is created
        // it is stored in the #template-info HTML element
        return ("true" == m_info["editMode"]);
    }


    function gridInfo() {
        // function wrapper for the gridInfo variable
        return m_gridInfo;
    }


    function initGridInfo() {
        // update grid size from CSS
        m_gridInfo.grid = getCssDataFromId('template-grid-info');
        if (DEBUG) console.info("Mercury grid size: " + m_gridInfo.grid);

        var gridInfo = getCssDataFromId('template-grid-info', true);
        gridInfo = gridInfo.replace(new RegExp('px', 'g'), '');
        if (DEBUG) console.info("Mercury grid info: [" + gridInfo + "]");
        if (isNotEmpty(gridInfo)) {
            jQ.extend(m_gridInfo, JSON.parse(gridInfo));
        }
        if (DEBUG) console.info("Mercury screen xs max:" + m_gridInfo.xsMax + " xl min:" + m_gridInfo.xlMin  + " desktop head nav min:" + m_gridInfo.navDeskMin);
        if (DEBUG) console.info("Mercury fixed header nav setting: " + m_gridInfo.navFixHeader);

        m_gridInfo.currentSize = function() {
            if (m_windowWidth <= this.xsMax) {
                return "xs";
            }
            if (m_windowWidth <= this.smMax) {
                return "sm";
            }
            if (m_windowWidth <= this.mdMax) {
                return "md";
            }
            if (m_windowWidth <= this.lgMax) {
                return "lg";
            }
            if (m_windowWidth >= this.xlMin) {
                return "xl";
            }
            return "unknown";
        }

        m_gridInfo.navType = function() {
            if (m_windowWidth <= this.navMobMax) {
                return "mobile";
            }
            if (m_windowWidth >= this.navDeskMin) {
                return "desktop";
            }
            return "unknown";
        }

        m_gridInfo.isMaxXs = function() { return m_windowWidth <= this.xsMax };
        m_gridInfo.isMaxSm = function() { return m_windowWidth <= this.smMax };
        m_gridInfo.isMaxMd = function() { return m_windowWidth <= this.mdMax };
        m_gridInfo.isMaxLg = function() { return m_windowWidth <= this.lgMax };

        m_gridInfo.isMinSm = function() { return m_windowWidth >= this.smMin };
        m_gridInfo.isMinMd = function() { return m_windowWidth >= this.mdMin };
        m_gridInfo.isMinLg = function() { return m_windowWidth >= this.lgMin };
        m_gridInfo.isMinXl = function() { return m_windowWidth >= this.xlMin };

        m_gridInfo.forceMobileNav = function() { return (this.navDeskMin < 5) };
        m_gridInfo.getNavFixHeader = function() { return (this.navFixHeader) };
        m_gridInfo.isDesktopNav = function() { return (!m_gridInfo.forceMobileNav()) && (m_windowWidth >= this.navDeskMin) };
        m_gridInfo.isMobileNav = function() { return (m_gridInfo.forceMobileNav()) || (m_windowWidth < this.navDeskMin) };
        m_gridInfo.navPos = function() { return this.navMobPos };
    }


    function calcRatio(ratio) {
        // calculates the ratio of an image based on its pixel size
        // used by some plugins (e.g. RevSlider)
        // the argument "ratio" has to have the format of the "image.size" property in OpenCms
        var result = {};
        result.valid = false;
        if (ratio != '') {
            ratio = ratio.toString();
            var i = ratio.indexOf('-');
            if (i > 0) {
                ratio = ratio.replace(',', '.');
                var wd = parseFloat(ratio.substring(0, i));
                var hd = parseFloat(ratio.substring(i + 1));
                result.wd = wd;
                result.hd = hd;
                result.ratio = wd / hd;
                result.valid = true;
            }
        }
        return result;
    }


    function post(path, params, method) {
        method = method || "post"; // Set method to post by default if not specified.

        var form = document.createElement("form");
        form.setAttribute("method", method);
        form.setAttribute("action", path);

        for(var key in params) {
            if(params.hasOwnProperty(key)) {
                var hiddenField = document.createElement("input");
                hiddenField.setAttribute("type", "hidden");
                hiddenField.setAttribute("name", key);
                hiddenField.setAttribute("value", params[key]);

                form.appendChild(hiddenField);
             }
        }

        document.body.appendChild(form);
        form.submit();
    }


    function scrollToAnchor($anchor, offset) {
        NavigationElements.scrollToAnchor($anchor, offset);
    }


    function initJavaScriptMarker() {
        // adds a CSS class "hasscript" to the document body so CSS can react if JS is available or not
        // when initially loaded, the page has the class "noscript" attached
        jQ(document.documentElement).removeClass("noscript");
        jQ(document.documentElement).addClass("hasscript");
    }


    function initFitVids() {
        // set video widths using the fidVids plugin
        fitVids({
            players: [ 'iframe[src*="slideshare.net"]', 'iframe[src*="medien-tube.de"]', 'iframe[src*="domradio.de"]' ],
            ignore: ['.type-media .content iframe'] // ignore all media elements
        });
    }


    function initTabAccordion(callback) {
        // add handler for elements hidden in accordions and tabs
        jQ('.accordion, .collapse').on('shown.bs.collapse', callback);
        jQ('a[data-toggle="tab"]').on('shown.bs.tab', callback);
    }


    // Affix elements, restricted to a parent container
    var m_affixElements = [];

    // Update Affix elements
    function updateAffix() {
        if (VERBOSE) console.info("Affix: update, m_affixElements=" + m_affixElements.length);
        for (var i=0; i<m_affixElements.length; i++) {
            var th = toolbarHeight();
            var affix = m_affixElements[i];
            var $element = affix.$element;
            var $parent =  affix.$parent;
            var topOffset = affix.top;
            var topOffsetFixed = affix.topFixed;
            var pHeight = $parent.outerHeight(true);
            var eHeight = $element.outerHeight(true);
            var docHeight = jQ(document).height();
            var scrollTop = m_$window.scrollTop();
            var top = $parent.offset().top - th + topOffset - topOffsetFixed;
            var bottom = top + (pHeight - eHeight) - topOffset;

            if (VERBOSE) console.info("Affix: docHeight=" + docHeight + " pHeight=" +  pHeight + " eHeight=" +  eHeight + " top=" + top + " bottom=" + bottom + " scrollTop=" + scrollTop);

            var isFixedTop = scrollTop > top;
            var isFixedBottom = isFixedTop && (scrollTop >= bottom);

            if (VERBOSE) console.info("Affix isFixed=" + (isFixedTop || isFixedBottom) + " isFixedTop=" + isFixedTop + " isFixedBottom=" + isFixedBottom);
            if (isFixedBottom) {
                $element.removeClass("affix affix-top").addClass("affix-bottom");
                $element.css("top", pHeight - eHeight);
            } else if (isFixedTop) {
                $element.removeClass("affix-top affix-bottom").addClass("affix");
                $element.css("top", th + topOffsetFixed);
            } else {
                $element.removeClass("affix-bottom affix").addClass("affix-top");
                $element.css("top", topOffset);
            }
        }
    }

    // Init Affix elements
    function initAffixes() {
        var $affixes = jQ('.affix-parent .affix-box');
        if (DEBUG) console.info("Mercury.initAffixes() .affix-parent .affix-box elements found: " + $affixes.length);
        $affixes.each(function() {
            var $element = jQ(this);
            var $parent = $element.parents(".affix-parent").first();
            var affix = {};
            affix.$element = $element;
            affix.$parent = $parent;
            var topCss = $element.css("top");
            if (typeof topCss !== "undefined") { topCss = topCss.match(/-?\d+/) } else { topCss = "0" };
            var options = getCssDataFromJQuery($element);
            var data = parseJson(options);
            if (typeof data.topFixed === "undefined" ) { data.topFixed = 0 };
            if (VERBOSE) console.info("Affix: css JSON data is=" + options + " topFixed=" + data.topFixed);
            affix.top = parseInt(topCss, 10);
            affix.topFixed = data.topFixed;
            m_affixElements.push(affix);
            if (VERBOSE) console.info("Affix: added top=" + affix.top + " topFixed=" + affix.topFixed);
        });
        if (m_affixElements.length > 0) {
            m_$window.on('scroll resize', function() { updateAffix() }); // can not use debouce, will be to "jaggy"
            updateAffix(true);
        }
    }


    function update(parent) {
        // called by Ajax methods to update dynamic template elements
        // used for example after new elements have been loaded in dynamic lists
        if (DEBUG) console.info("Mercury.update() parent=" + parent);

        initFitVids();
        // in case a dynamic list contains audio elements, make sure the required audio script is available
        loadAudioScript(function() { initMedia(parent) });
        initOnclickActivation(parent);
        initTooltips(parent);

        // run registered update callbacks
        for (var i=0; i < m_updateCallbacks.length; i++) {
            try {
                if (DEBUG) console.info("Mercury.update() running callback: " + m_updateCallbacks[i].name);
                m_updateCallbacks[i](jQ, DEBUG, parent);
            } catch (err) {
                console.warn("Mercury.update() error in callback", err);
            }
        }

        // reset the OpenCms edit buttons
        debounce(_OpenCmsReinitEditButtons, 500);
    }


    function addUpdateCallback(callback) {
        if (typeof callback === "function") {
            if (DEBUG) console.info("Mercury.addUpdateCallback() added function: " + callback.name);
            m_updateCallbacks.push(callback);
        } else {
            console.warn("Mercury.addUpdateCallback() added object is not a function", callback);
        }
    }


    function loadAudioScript(callback) {
        // load audio script if required
        var audioScriptRequired = requiresModule(".type-media.audio, [data-audio]");
        if (audioScriptRequired && ((typeof window.AudioData === "undefined") || (typeof window.AudioData.initAudioElement !== "function"))) {
            window.AudioData = false;
            if (DEBUG) console.info("Mercury.loadAudioScript() - Loading audio script...");
            try {
                import(
                    /* webpackChunkName: "mercury-audio" */
                    "./audio.js").then( function ( AudioData ) {
                    if (DEBUG) console.info("Mercury.loadAudioScript() - Audio script was loaded!");
                    AudioData.init(jQ, DEBUG);
                    window.AudioData = AudioData;
                    if (typeof callback === "function") {
                        callback();
                    }
                });
            } catch (err) {
                console.warn("Mercury.loadAudioScript() error", err);
            }
        } else {
            if (DEBUG) console.info("Mercury.loadAudioScript() - Audio script " + (audioScriptRequired ? "alreay loaded." : "not required."));
            if (typeof callback === "function") {
                callback();
            }
        }
    }


    function initLazyImageLoading() {
        // initialize lazy loading of images using the lazySizes plugin
        var lazySizesCfg = { init:true };
        if (device().desktop()) {
            lazySizesCfg.expFactor = 2.0; // load elements "not so near" for desktop
            lazySizesCfg.loadMode = 3; // load elements "not so near" for desktop
        } else {
            lazySizesCfg.loadMode = 1; // only load visible elements for mobile
        }
        // see https://github.com/aFarkas/lazysizes/issues/410
        Object.assign(lazySizes.cfg, lazySizesCfg);
        lazySizes.init();
    }


    function initTooltips(parent) {
        // initialize bootstrap tooltips
        parent = parent || '';
        var selector = parent + ' [data-toggle="tooltip"]';
        var $tooltips = jQ(selector);
        if (DEBUG) console.info("Mercury.initTooltips() " + selector + " elements found: " +  $tooltips.length);
            if ($tooltips.length > 0) {
            $tooltips.tooltip({
                container: 'body',
                placement: 'top',
                delay: { 'show': 100, 'hide': 100 }
            });
            if (!device().desktop()) {
                // automatically close the tooltip
                $tooltips.on('shown.bs.tooltip', function (event) {
                    setTimeout(function () {
                        $(event.target).tooltip('hide');
                    }, 2500);
                });
            }
        }
    }


    function initPlaceholder($element, callback) {
        if (isEditMode() && (typeof $element.data("placeholder") !== "undefined")) {
            // add the hide element class
            $element.addClass("placeholder");
            if (! $element.hasClass("error")) {
                // .placeholder.error class should NOT call the callback
                jQ($element).on("click",function(event) {
                    // remove handler and remove class when clicked
                    jQ(event.currentTarget).off("click")
                        jQ(event.currentTarget).removeClass("placeholder");
                        callback(event);
                    }
                );
            }
            return true;
        }
        return false;
    }


    function revalOnClickTemplate($element, template, isMedia, autoplay) {
        if (DEBUG) console.info("revalOnClickTemplate(): isMedia=" + isMedia + " autoplay=" + autoplay);
        $element.removeClass("reveal-registered");
        $element.off("click");
        $element.off("keydown");
        var $p = $element.parent();
        $p.removeClass("concealed enlarged");
        $p.addClass("revealed");
        if (template == "audio") {
            autoplay = (typeof autoplay === "undefined") ? true : autoplay;
            if (window.AudioData) {
                window.AudioData.initAudioElement($element, autoplay);
            }
        } else {
            var $piece = $element.parents(".effect-piece").first();
            $piece.removeClass("effect-raise effect-shadow effect-rotate effect-box");
            var $mediaBox =  $element.parents(".media-box.removable");
            if ($mediaBox.length > 0) {
                $mediaBox.removeClass().css("padding-bottom", "").addClass("media-box-removed");
                $mediaBox.find(".content").removeClass().addClass("content-removed")
            }
            $element.remove();
            $p.append(decodeURIComponent(template));
            initFitVids();
        }
    }


    function registerRevealFunttion($element, template, isMedia, autoplay) {
        // adds a placeholder that has to be clicked in edit mode in order to reveal the template
        // mostly used for JavaScripts that contact external servers which may not be wanted in edit mode
        var revealFunction = function() {
            // first we create a finction that revelas the template when clicked
            revalOnClickTemplate($element, template, isMedia, autoplay);
        };
        if (!initPlaceholder($element, revealFunction)) {
            // check if a placeholder is required in edit mode, otherwise directly show the element
            revealFunction();
        }
    }


    function checkOnClickTemplateCookies(event) {
        var data = event.data;
        var cookieData = data.$element.data("modal-external-cookies");
        if (!cookieData || PrivacyPolicy.cookiesAcceptedExternal()) {
            revalOnClickTemplate(data.$element, data.template, data.isMedia);
        } else {
            PrivacyPolicy.createExternalElementModal(cookieData.header, cookieData.message, cookieData.footer,
            function() {
                revalOnClickTemplate(data.$element, cata.template, cata.isMedia);
            });
        }
    }


    function initOnclickTemplates(selector, isMedia) {
        var $onclickTemplates = jQ(selector);
        if (DEBUG) console.info("Mercury.initOnclickTemplates(): " + selector + " elements found: " + $onclickTemplates.length);
        $onclickTemplates.each(function() {

            var $element = jQ(this);
            var data = $element.data("preview");
            if (data && data.template) {
                var template = data.template;
                var color = getThemeJSON("main-theme");
                data.isMedia = isMedia;
                data.$element = $element;
                if (typeof color !== "undefined") {
                    template = template.replace("XXcolor-main-themeXX", color.substring(1));
                }
                if ($element.width() < 300) {
                    $element.addClass("narrow");
                }
                // for autoplay check if element is rendered in our template - like e.g. the audio player - or from an external server
                var noAutoPlay = (template == "audio") && (!PrivacyPolicy.cookiesAcceptedExternal() || isEditMode());
                if ($element.hasClass("ensure-external-cookies") && !noAutoPlay) {
                    // this element requires external coodies to be accepted before it is shown
                    // if cookies are not accepted the external cookie notice will be rendered from initExternalElements() in privacy-policy.js
                    if (PrivacyPolicy.cookiesAcceptedExternal()) {
                        // only render this if external cookies are allowed
                        registerRevealFunttion($element, template, isMedia, !isEditMode());
                    }
                } else if ($element.hasClass("placeholder-in-editor") && !noAutoPlay) {
                    // this element has a placeholder so it should NOT be shown direclty in edit mode, only online or in preview mode
                    registerRevealFunttion($element, template, isMedia, !isEditMode());
                } else {
                    // this element has a preview template that has to be clicked before the external content is shown
                    if (! $element.hasClass("reveal-registered")) {
                        // only attach event listerners once, important for dynamic lists
                        $element.addClass("reveal-registered");
                        $element.on("click", data, checkOnClickTemplateCookies);
                        $element.on("keydown", data, function(e) {
                            if (e.which == 13) { checkOnClickTemplateCookies(e); }
                        });
                    }
                }
            }
        });
    }


    function initMedia(parent) {
        // initialize Media element click handlers
        parent = parent || '';
        initOnclickTemplates(parent + ' .type-media .preview.inline', true);
    }


    function initOnclickActivation(parent) {
        // add click handlers to generic onclick activation elements
        parent = parent || '';
        initOnclickTemplates(parent + ' .onclick-activation', false);
    }


    function addInit(initFunction) {
        // add a function to the template script init process
        if (DEBUG) console.info("Mercury added init function: " + initFunction.name);
        window.mercury(initFunction);
    }


    function initScripts() {
        // register additional JavaScripts to the template init process
        // the idea is that additional JavaScrips are started from here rather then registering their own "window.onload" event
        // this way it can be ensured that the required page functions are already initialized when the additional JS is executed
        var $initScripts = jQ('.mercury-initscript');
        if (DEBUG) console.info("Mercury.initScripts() .mercury-initscript elements found: " + $initScripts.length);
        $initScripts.each(function() {

            var $element = jQ(this);
            if (typeof $element.data("script") !== "undefined") {
                var script = $element.data("script");
                if (DEBUG) console.info("initscript found:" + script);
                addInit(window[script]);
            }
        });
    }


    function initFunctions() {
        // calls all init() functions that have registered
        var _functions = window.mercury.getInitFunctions();
        for (var i=0; i < _functions.length; i++) {
            try {
                var initFunction = _functions[i];
                if (DEBUG) console.info("Mercury executing init function: " + initFunction.name);
                initFunction(jQ, DEBUG);
            } catch (err) {
                console.warn("Mercury.initFunctions() error", err);
            }
        }
    }


    function requiresModule(selector) {
        // checks if a specific module is required by checking for special selectors
        return (jQ(selector).length > 0);
    }


    var m_cssTimer = 0;
    function waitForCss() {
        var element = document.getElementById("template-info");
        if (window.getComputedStyle(element).visibility == "hidden") {
            initAfterCss();
        } else {
            m_cssTimer += 50;
            setTimeout(function() { waitForCss() }, 50);
        }
    }


    function initAfterCss() {

        if (DEBUG) console.info("Mercury.initAfterCss() - CSS wait time: " + m_cssTimer + "ms");
        if (DEBUG) console.info("Mercury device info: " + device().type);

        // initialize
        try {
            initInfo();
        } catch (err) {
            console.warn("Mercury.initInfo() error", err);
        }

        try {
            initAffixes();
        } catch (err) {
            console.warn("Mercury.initAffixes() error", err);
        }

        try {
            PrivacyPolicy.init(jQ, DEBUG);
            window.PrivacyPolicy = PrivacyPolicy;
        } catch (err) {
            console.warn("PrivacyPolicy.init() error", err);
        }

        try {
            update();
        } catch (err) {
            console.warn("Mercury.update() error", err);
        }

        try {
            NavigationElements.init(jQ, DEBUG, VERBOSE);
        } catch (err) {
            console.warn("Navigation.init() error", err);
        }

        try {
            DynamicListElemements.init(jQ, DEBUG);
            window.DynamicList = DynamicListElemements;
        } catch (err) {
            console.warn("List.init() error", err);
        }

        try {
            CommentElements.init(jQ, DEBUG);
        } catch (err) {
            console.warn("Comments.init() error", err);
        }

        try {
            AnalyticElements.init(jQ, DEBUG);
        } catch (err) {
            console.warn("Analytics.init() error", err);
        }

        // now initialize optional modules

        if (requiresModule(".type-slick-slider .slide-definitions.list-of-slides")) {
            try {
                import(
                    /* webpackChunkName: "mercury-slider-slick" */
                    "./slider-slick.js").then( function ( SliderSlick ) {
                    SliderSlick.init(jQ, DEBUG);
                });
            } catch (err) {
                console.warn("SliderSlick.init() error", err);
            }
        }

        if (requiresModule(".map-osm")) {
            try {
                 import(
                    /* webpackChunkName: "mercury-map-osm" */
                    "./map-osm.js").then( function ( OsmMap ) {
                       OsmMap.init(jQ, DEBUG);
                       window.OsmMap = OsmMap;
                       window.dispatchEvent(new CustomEvent("load-module-map-osm", {
                           detail: OsmMap
                       }));
                 });
            } catch (err) {
                 console.warn("OsmMap.init() error", err);
            }
        }

        if (requiresModule(".map-google")) {
            try {
                import(
                    /* webpackChunkName: "mercury-map-google" */
                    "./map-google.js").then( function ( GoogleMap ) {
                    window.GoogleMap = GoogleMap;
                    let response = GoogleMap.init(jQ, DEBUG);
                    if (response) {
                        response.then(function(event) {
                            window.dispatchEvent(new CustomEvent("load-module-map-google", {
                                detail: GoogleMap
                            }));
                        });
                    } else { // Google map was loaded already
                        window.dispatchEvent(new CustomEvent("load-module-map-google", {
                            detail: GoogleMap
                        }));
                    }
                });
            } catch (err) {
                 console.warn("GoogleMap.init() error", err);
            }
        }

        if (requiresModule(".masonry-list")) {
            try {
                import(
                    /* webpackChunkName: "mercury-masonry-list" */
                    "./lists-masonry.js").then( function ( MasonryList ) {
                    MasonryList.init(jQ, DEBUG);
                });
            } catch (err) {
                console.warn("MasonryList.init() error", err);
            }
        }

        if (requiresModule(".datepicker")) {
            try {
                import(
                    /* webpackChunkName: "mercury-datepicker" */
                    "./datepicker.js").then( function ( DatePicker ) {
                    DatePicker.init(jQ, DEBUG, getLocale());
                });
            } catch (err) {
                console.warn("DatePicker.init() error", err);
            }
        }

        if (requiresModule(".type-imageseries, [data-imagezoom]")) {
            try {
                import(
                    /* webpackChunkName: "mercury-imageseries" */
                    "./imageseries.js").then( function ( ImageSeries ) {
                    ImageSeries.init(jQ, DEBUG);
                    window.ImageSeries = ImageSeries;
                });
            } catch (err) {
                console.warn("ImageSeries.init() error", err);
            }
        }

        if (requiresModule(".type-shariff")) {
            try {
                import(
                    /* webpackChunkName: "mercury-shariff" */
                    "shariff/dist/shariff.min.js").then( function(Shariff) {
                    if (DEBUG) console.info("Shariff module loaded!");
                });
            } catch (err) {
                console.warn("Shariff.init() error", err);
            }
        }

        if (requiresModule(".effect-parallax-bg")) {
            try {
                import(
                    /* webpackChunkName: "mercury-tools" */
                    "./parallax.js").then( function( TemplateTools ) {
                    TemplateTools.initParallax(jQ, DEBUG, VERBOSE);
                });
            } catch (err) {
                console.warn("Parallax.init() error", err);
            }
        }

        if (requiresModule(".template-info.sample")) {
            try {
                import(
                    /* webpackChunkName: "mercury-tools" */
                    "./csssampler.js").then( function( TemplateTools ) {
                    TemplateTools.initCssSampler(jQ, DEBUG);
                });
            } catch (err) {
                console.warn("CssSampler.init() error", err);
            }
        }

        try {
            // this must come directly before initFunctions()
            initScripts();
        } catch (err) {
            console.warn("Mercury.initScripts() error", err);
        }
        try {
            // this must come last
            initFunctions();
        } catch (err) {
            console.warn("Mercury.initFunctions() error", err);
        }

        // add event listeners for Bootstrap elements
        _OpenCmsInit(jQ, DEBUG)
    }


    function init() {
        // main init function - called from jQuery(document).ready() - see below in this script
        if (DEBUG) console.info("Mercury.init() - Modularized version");
        window.Mercury = Mercury;

        try {
            initJavaScriptMarker();
        } catch (err) {
            console.warn("Mercury.initJavaScriptMarker() error", err);
        }
        try {
            initLazyImageLoading();
        } catch (err) {
            console.warn("Mercury.initLazyImageLoading() error", err);
        }

        waitForCss();
    }


    // public available functions
    return {
        init: init,
        addContext: addContext,
        addUpdateCallback: addUpdateCallback,
        calcRatio: calcRatio,
        debounce: debounce,
        device: device,
        getCssJsonData: getCssJsonData,
        getInfo: getInfo,
        getLocale: getLocale,
        getParameter: getParameter,
        getThemeJSON: getThemeJSON,
        gridInfo: gridInfo,
        hasInfo: hasInfo,
        initElements: update,
        initPlaceholder: initPlaceholder,
        initTabAccordion: initTabAccordion,
        isEditMode: isEditMode,
        isOnlineProject: isOnlineProject,
        post: post,
        scrollToAnchor: scrollToAnchor,
        toolbarHeight: toolbarHeight,
        update: update,
        windowHeight: windowHeight,
        windowWidth: windowWidth,
        windowScrollTop: windowScrollTop
    }

}(jQuery);


//webpack: setting the public path for the exported modules that are dynamically loaded
//see https://webpack.js.org/guides/public-path/
__webpack_public_path__ = function() {
    return __scriptPath.replace("/mercury.js", "/");
}();


jQuery(document).ready(function() {
    Mercury.init();
});

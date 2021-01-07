<%@ tag pageEncoding="UTF-8"
    display-name="media-vars"
    body-content="scriptless"
    trimDirectiveWhitespaces="true"
    description="Reads a media content and sets a series of variables for quick acesss." %>


<%@ attribute name="content" type="org.opencms.jsp.util.CmsJspContentAccessBean" required="true"
    description="The media content to use." %>

<%@ attribute name="ratio" type="java.lang.String" required="true"
    description="Can be used to scale the media in a specific ratio.
    Example values are: '1-1', '4-3', '3-2', '16-9', '2-1', '2,35-1' or 3-1." %>

<%@ attribute name="autoPlay" type="java.lang.Boolean" required="false"
    description="Controls if the media is directly played without clicking on the element first. Default is 'false'." %>

<%@ attribute name="mediaCheckOnly" type="java.lang.Boolean" required="false"
    description="If 'true' only a quick check to find out which media is used will be performed. Default is 'false'." %>


<%@ variable name-given="image" declare="true"
    description="The optional image of the media file, as set in the content." %>

<%@ variable name-given="copyright" declare="true"
    description="The optional copyright of the media file, as set in the content." %>

<%@ variable name-given="width" declare="true"
    description="The width of the media file, taken from the ratio." %>

<%@ variable name-given="height" declare="true"
    description="The height of the media file, taken from the ratio." %>

<%@ variable name-given="usedRatio" declare="true"
    description="The ratio actually used for the media display, considering defaults if no ratio has been provided.
    Example values are: '1-1', '4-3', '3-2', '16-9', '2-1', '2,35-1' or 3-1." %>

<%@ variable name-given="isYouTube" declare="true"
    description="If true, the media file is a YouTube video." %>

<%@ variable name-given="isSoundCloud" declare="true"
    description="If true, the media file is a SoundCloud audio track." %>

<%@ variable name-given="isAudio" declare="true"
    description="If true, the media file is an audio track." %>

<%@ variable name-given="isFlexible" declare="true"
    description="If true, the media is created form a flexible embed code." %>

<%@ variable name-given="youTubeId" declare="true"
    description="The ID of the YouTube video." %>

<%@ variable name-given="youTubePreviewImg" declare="true"
    description="The preview image for the YouTube video." %>

<%@ variable name-given="youTubePreviewHtml" declare="true"
    description="The full HTML markup for the YouTube video preview image." %>

<%@ variable name-given="template" declare="true"
    description="The template to use for the media file." %>

<%@ variable name-given="icon" declare="true"
    description="The overlay icon for the media file." %>

<%@ variable name-given="cssClass" declare="true"
    description="An additional CSS class to be used in the HTML generated later." %>

<%@ variable name-given="cookieMessage" declare="true"
    description="The message to display if external cookies have not been accepted." %>

<%@ variable name-given="placeholderMessage" declare="true"
    description="The message to display for the placeholder (only for autoplay media element)." %>


<%@ variable name-given="caseNotInList" declare="true" %>
<%@ variable name-given="caseStaticList" declare="true" %>
<%@ variable name-given="caseStandardElement" declare="true" %>
<%@ variable name-given="caseDynamicListAjax" declare="true" %>
<%@ variable name-given="caseDynamicListNoscript" declare="true" %>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>

<c:choose>
    <c:when test="${content.value.MediaContent.value.YouTube.isSet}">
        <c:set var="isYouTube" value="${true}" />
    </c:when>
    <c:when test="${content.value.MediaContent.value.SoundCloud.isSet}">
        <c:set var="isSoundCloud" value="${true}" />
    </c:when>
    <c:when test="${content.value.MediaContent.value.Audio.isSet}">
        <c:set var="isAudio" value="${true}" />
    </c:when>
    <c:when test="${content.value.MediaContent.value.Flexible.isSet}">
        <c:set var="isFlexible" value="${true}" />
    </c:when>
</c:choose>

<c:set var="width" value="${cms:mathRound(cms:toNumber(fn:substringBefore(ratio, '-'), 4))}" />
<c:set var="height" value="${cms:mathRound(cms:toNumber(fn:substringAfter(ratio, '-'), 3))}" />
<c:set var="usedRatio" value="${width}-${height}" />

<c:if test="${not mediacheckonly}">

    <mercury:list-element-status>

    <c:if test="${content.value.Image.isSet}">
        <c:set var="image" value="${content.value.Image}" />
    </c:if>

    <c:if test="${content.value.Copyright.isSet}">
        <c:set var="copyright" value="${content.value.Copyright}" />
    </c:if>

    <fmt:setLocale value="${cms.locale}" />
    <cms:bundle basename="alkacon.mercury.template.messages">

    <c:choose>

        <c:when test="${isYouTube}">
            <c:set var="cookieMessage"><fmt:message key="msg.page.privacypolicy.message.media.youtube" /></c:set>
            <c:set var="placeholderMessage"><fmt:message key="msg.page.placeholder.media.youtube" /></c:set>
            <c:set var="youTubeId" value="${content.value.MediaContent.value.YouTube.value.YouTubeId}" />
            <c:set var="defaultPreview"><mercury:schema-param param="mercuryYouTubePreviewDefault" /></c:set>
            <c:set var="youTubePreviewImg" value="${content.value.MediaContent.value.YouTube.value.YouTubePreview.isSet ?
                content.value.MediaContent.value.YouTube.value.YouTubePreview : defaultPreview}" />
            <c:set var="template"><%--
            --%><iframe src="https://www.youtube-nocookie.com/embed/${youTubeId}?<%--
                --%>autoplay=1&rel=0&iv_load_policy=3&modestbranding=1" <%--
                --%>style="border: none;" allow="autoplay; encrypted-media" allowfullscreen><%--
            --%></iframe><%----%>
            </c:set>
            <c:set var="icon" value="fa-youtube-play" />
            <c:set var="cssClass" value="video" />

            <c:choose>
                <c:when test="${youTubePreviewImg eq 'none'}">
                    <c:set var="youTubePreviewHtml" value="${null}" />
                </c:when>
                <c:otherwise>
                    <c:set var="youTubePreviewHtml">
                        <c:set var="srcSet"><%--
                        --%>https://img.youtube.com/vi/${youTubeId}/default.jpg 120w, <%--
                        --%>https://img.youtube.com/vi/${youTubeId}/hqdefault.jpg 480w</c:set>
                        <c:if test="${not (youTubePreviewImg eq 'hqdefault.jpg')}">
                            <c:set var="srcSet" value="${srcSet}, https://img.youtube.com/vi/${youTubeId}/${youTubePreviewImg} 640w" />
                        </c:if>
                        <mercury:image-lazyload
                            srcUrl="https://img.youtube.com/vi/${youTubeId}/${youTubePreviewImg}"
                            srcSet="${srcSet}"
                            alt="${content.value.Title}"
                            cssImage="animated"
                            noScript="${caseStandardElement}"
                            lazyLoad="${not caseDynamicListNoscript}"
                        />
                    </c:set>
                </c:otherwise>
            </c:choose>
        </c:when>

        <c:when test="${isSoundCloud}">
            <c:set var="cookieMessage"><fmt:message key="msg.page.privacypolicy.message.media.soundcloud" /></c:set>
            <c:set var="placeholderMessage"><fmt:message key="msg.page.placeholder.media.soundcloud" /></c:set>
            <c:set var="soundCloudTrackId" value="${content.value.MediaContent.value.SoundCloud.value.SoundCloudTrackId}" />
            <c:set var="template"><%--
                --%><iframe width="100%" height="100%" scrolling="no" style="border: none;" allow="autoplay" <%--
                --%>src="https://w.soundcloud.com/player/?url=<%--
                    --%>https%3A//api.soundcloud.com/tracks/${soundCloudTrackId}&<%--
                        --%>auto_play=true&<%--
                        --%>color=%23XXcolor-main-themeXX&<%--
                        --%>buying=false&<%--
                        --%>sharing=true&<%--
                        --%>show_user=true&<%--
                        --%>hide_related=true&<%--
                        --%>show_comments=false&<%--
                        --%>show_reposts=false&<%--
                        --%>show_teaser=false&<%--
                        --%>visual=true"><%--
            --%></iframe><%----%>
            </c:set>
            <c:set var="icon" value="fa-soundcloud" />
        </c:when>

        <c:when test="${isAudio}">
            <c:set var="cookieMessage"><fmt:message key="msg.page.privacypolicy.message.media.audio" /></c:set>
            <c:set var="placeholderMessage"><fmt:message key="msg.page.placeholder.media.audio" /></c:set>
            <c:set var="isAudio" value="${true}" />
            <c:set var="useMediaEl" value="${false}" />
            <c:set var="audioUri" value="${content.value.MediaContent.value.Audio.value.URI.toLink}" />
            <c:set var="audioId"><mercury:idgen prefix="wf" uuid="${cms.element.instanceId}" /></c:set>
            <%-- Generate audio data JSON --%>
            <cms:jsonobject var="audioData">
                <cms:jsonvalue key="id" value="${audioId}" />
                <cms:jsonvalue key="src" value="${audioUri}" />
                <cms:jsonvalue key="mediael" value="${useMediaEl}" />
                <cms:jsonvalue key="autoplay" value="${autoPlay}" />
                <cms:jsonvalue key="loadtxt" value="Lade (%percent)" />
            </cms:jsonobject>
            <c:set var="template">
                <div class="preview revealed">
                    <c:choose>
                        <c:when test="${not empty image}">
                            <mercury:image-animated image="${image}" ratio="${usedRatio}" title="${content.value.Title}" />
                        </c:when>
                        <c:otherwise>
                            <div class="centered">No image...</div><%----%>
                        </c:otherwise>
                    </c:choose>
                    <div class="audio-box">
                        <div class="audio-player" data-audio='${audioData.compact}'>
                            <div class="audio-progress">
                                <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <div class="audio-controls">
                                <div class="audio-pos"></div>
                                <div class="audio-buttons">
                                    <div class="fa fa-stop audio-stop"></div>
                                    <div class="fa fa-play audio-play"></div>
                                    <div class="fa fa-forward audio-skip"></div>
                                </div>
                                <div class="audio-length"></div>
                            </div>

                            <%--
                            <div class="wave-time"></div>
                            <div class="wave-form-wrapper">
                                <div id="${audioId}" class="wave-form"></div>
                            </div>
                            <c:if test="${useMediaEl}">
                                <audio controls src="${audioUri}" class="wave-audio"></audio>
                            </c:if>
                            --%>
                        </div>
                    </div>
                </div><%----%>
            </c:set>
            <c:set var="icon" value="fa-play" />
        </c:when>

        <c:when test="${isFlexible}">
            <c:set var="cookieMessage"><fmt:message key="msg.page.privacypolicy.message.media.generic" /></c:set>
            <c:set var="placeholderMessage"><fmt:message key="msg.page.placeholder.media.generic" /></c:set>
            <c:set var="template" value="${content.value.MediaContent.value.Flexible.value.Code}" />
            <c:choose>
                <c:when test="${content.value.MediaContent.value.Flexible.value.Icon.isSet}">
                    <c:set var="icon" value="fa-${content.value.MediaContent.value.Flexible.value.Icon}" />
                </c:when>
                <c:otherwise>
                    <c:set var="icon" value="fa-play" />
                </c:otherwise>
            </c:choose>
        </c:when>

    </c:choose>

    </cms:bundle>

    </mercury:list-element-status>

</c:if>

<jsp:doBody/>
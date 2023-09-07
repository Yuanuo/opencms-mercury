<%@page
    pageEncoding="UTF-8"
    buffer="none"
    session="false"
    trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>

<cms:formatter var="content" val="value">

<mercury:setting-defaults>

<c:set var="variant"            value="${value.Variant}" />
<c:set var="setting"            value="${cms.element.setting}" />
<c:set var="detailContainer"    value="${setting.detailContainer.toString}" />
<c:set var="reverseOrder"       value="${setting.containerOrder.toString eq 'reversed'}" />

<c:set var="isMainDetail"       value="${(detailContainer eq 'maincol') or (detailContainer eq 'maincust')}" />
<c:set var="mainDetailType"     value="${detailContainer eq 'maincust' ? 'special' : 'element'}" />

<c:set var="cssWrapper"         value="${setCssWrapperAll}" />

<jsp:useBean id="valueMap"      class="java.util.HashMap" />

<mercury:container-box label="${value.Title}" boxType="model-start" />
<mercury:nl />

<c:choose>
    <c:when test="${variant eq '12'}">
        <%-- lr_00001 --%>
        <c:set target="${valueMap}" property="Type"             value="${mainDetailType}"/>
        <c:set target="${valueMap}" property="Name"             value="maincol"/>
        <c:set target="${valueMap}" property="Css"              value="row-12${cssWrapper}" />
        <c:set target="${valueMap}" property="Parameters"       value="${{'cssgrid': 'col-xs-12'}}" />
        <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
    </c:when>
    <c:when test="${variant eq 'adjust'}">
        <%-- lr_00013 --%>
        <c:set var="colWidth"           value="${setting.colWidth.validate(['6','7','8','9','10','11','12'],'10').toInteger}" />
        <div class="row justify-content-lg-center${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-${colWidth + 1 <= 12 ? colWidth + 1 : 12} col-xl-${colWidth}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '3-9'}">
        <%-- lr_00002 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-9${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-3 col-side ${colCss}${reverseOrder ? ' order-first' : ' order-lg-first'}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '4-8'}">
        <%-- lr_00003 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-8${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-4 col-side ${colCss}${reverseOrder ? ' order-first' : ' order-lg-first'}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '6-6'}">
        <%-- lr_00004 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-6${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <mercury:container value="${valueMap}" title="${value.Title}"/>
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '6-6-sm'}">
        <%-- lr_00005 --%>
        <c:set var="colCss"            value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-md-6${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-md-6${colCss}${reverseOrder ? ' order-first order-md-last' : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '6-6-md'}">
        <%-- lr_00006 --%>
        <c:set var="colCss"            value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-6${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-6${colCss}${reverseOrder ? ' order-first order-lg-last' : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '9-3'}">
        <%-- lr_00007 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-9${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-3 col-side${colCss}${reverseOrder ? ' order-first order-lg-last' : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '8-4'}">
        <%-- lr_00008 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}">
            <mercury:nl />
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-8${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-4 col-side${colCss}${reverseOrder ? ' order-first order-lg-last' : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <mercury:nl />
        </div>
    </c:when>
    <c:when test="${variant eq '4-4-4'}">
        <%-- lr_00009 --%>
        <c:set var="colCss"            value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-4${colCss}${reverseOrder ? ' order-last order-lg-first' : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-4${colCss}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol1"/>
            <c:set target="${valueMap}" property="Css"          value="col-lg-4${colCss}${reverseOrder ? ' order-first order-lg-last' : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol1'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '3-3-3-3'}">
        <%-- lr_00010 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <c:set var="twoXsCols"          value="${setting.xsCols.toInteger eq 6}" />
        <c:set var="xsCols"             value="${twoXsCols ? 'col-6' : 'col-md-6'}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-lg-3${colCss}${reverseOrder ? (twoXsCols ? ' order-3' :' order-4).concat( order-md-3 order-lg-1') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-lg-3${colCss}${reverseOrder ? (twoXsCols ? ' order-4' :' order-3).concat( order-md-4 order-lg-2') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol1"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-lg-3${colCss}${reverseOrder ? (twoXsCols ? ' order-1' :' order-2).concat( order-md-1 order-lg-3') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol1'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol2"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-lg-3${colCss}${reverseOrder ? (twoXsCols ? ' order-2' :' order-1).concat( order-md-2 order-lg-4') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol2'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq '2-2-2-2-2-2'}">
        <%-- lr_00011 --%>
        <c:set var="colCss"             value="${setting.useFlex.toBoolean ? ' flex-col' : ''}" />
        <c:set var="twoXsCols"          value="${setting.xsCols.toInteger ne 12}" />
        <c:set var="xsCols"             value="${twoXsCols ? 'col-6' : 'col-12'}" />
        <div class="row${cssWrapper}"><%----%>
            <c:set target="${valueMap}" property="Type"         value="${mainDetailType}"/>
            <c:set target="${valueMap}" property="Name"         value="maincol"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-md-4 col-xl-2${colCss}${reverseOrder ? (twoXsCols ? ' order-5' : ' order-6').concat(' order-md-4 order-xl-1') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${isMainDetail}" />
            <c:set target="${valueMap}" property="Type"         value="element"/>
            <c:set target="${valueMap}" property="Name"         value="sidecol"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-md-4 col-xl-2${colCss}${reverseOrder ? (twoXsCols ? ' order-6' : ' order-5').concat(' order-md-5 order-xl-2') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'sidecol'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol1"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-md-4 col-xl-2${colCss}${reverseOrder ? (twoXsCols ? ' order-3' : ' order-4').concat(' order-md-6 order-xl-3') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol1'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol2"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-md-4 col-xl-2${colCss}${reverseOrder ? (twoXsCols ? ' order-4' : ' order-3').concat(' order-md-1 order-xl-4') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol2'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol3"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-md-4 col-xl-2${colCss}${reverseOrder ? (twoXsCols ? ' order-1' : ' order-2').concat(' order-md-2 order-xl-5') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol3'}" />
            <c:set target="${valueMap}" property="Name"         value="addcol4"/>
            <c:set target="${valueMap}" property="Css"          value="${xsCols} col-md-4 col-xl-2${colCss}${reverseOrder ? (twoXsCols ? ' order-2' : ' order-1').concat(' order-md-3 order-xl-6') : ''}" />
            <mercury:container value="${valueMap}" title="${value.Title}" detailView="${detailContainer eq 'addcol4'}" />
            <mercury:nl />
        </div><%----%>
    </c:when>
    <c:when test="${variant eq 'tile-row'}">
        <%-- lr_00012 - special row for tiles --%>
        <c:set var="tileCss"                                    value="${setting.tileCss.toString}" />
        <c:set var="tileMargin"                                 value="${setting.tileMargin.toString}" />

        <c:set var="useSquare"                                  value="${tileCss eq 'square'}" />
        <c:set var="useTile"                                    value="${not useSquare and not (tileCss eq 'none')}" />
        <c:set var="params"                                     value="${{'cssgrid': 'col-xs-12'}}" />
        <c:choose>
            <c:when test="${useSquare}">
                <%-- Generate square row --%>
                <c:set var="squareMargin"                       value="square-m-${fn:substringAfter(tileMargin, 'tile-margin-')}" />
                <c:set target="${valueMap}" property="Type"     value="square"/>
                <c:set target="${valueMap}" property="Css"      value="${'row-square '}${squareMargin}${cssWrapper}" />
                <c:set target="${params}"   property="tilegrid" value="" />
            </c:when>
            <c:when test="${useTile}">
                <%-- Generate tile row --%>
                <c:choose>
                    <c:when test="${false}"><%-- Disable the choices below - these are experimental --%></c:when>
                    <c:when test="${tileCss eq 'tile-col col-6 col-md-4 col-lg-3 col-xl-2'}">
                        <c:set var="tileMargin" value="row-cols-2 row-cols-md-3 row-cols-lg-4 row-cols-xl-6 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-6 col-md-4 col-xl-2'}">
                        <c:set var="tileMargin" value="row-cols-2 row-cols-md-3 row-cols-xl-6 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-6 col-lg-3'}">
                        <c:set var="tileMargin" value="row-cols-2 row-cols-lg-4 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-6'}">
                        <c:set var="tileMargin" value="row-cols-2 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-md-6 col-lg-3'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-md-2 row-cols-lg-4 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-md-6 col-lg-4 col-xl-3'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-md-6 col-xl-3'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-md-2 row-cols-xl-4 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-md-6 col-xl-4'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-md-2 row-cols-xl-3 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-lg-4'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-lg-3 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-md-6'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-md-2 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-lg-6'}">
                        <c:set var="tileMargin" value="row-cols-1 row-cols-lg-2 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                    <c:when test="${tileCss eq 'tile-col col-12'}">
                        <c:set var="tileMargin" value="row-cols-1 ${tileMargin}" />
                        <c:set var="tileCss"    value="tile-col col" />
                    </c:when>
                </c:choose>
                <c:set target="${valueMap}" property="Type"     value="tile"/>
                <c:set target="${valueMap}" property="Css"      value="${'row '}${tileMargin}${cssWrapper}" />
                <c:set target="${params}"   property="tilegrid" value="${tileCss}" />
            </c:when>
            <c:otherwise>
                <%-- Generate default row --%>
                <c:set target="${valueMap}" property="Type"     value="${mainDetailType}"/>
                <c:set target="${valueMap}" property="Css"      value="row-12${cssWrapper}" />
            </c:otherwise>
        </c:choose>
        <c:set target="${valueMap}" property="Name"             value="maincol"/>
        <c:set target="${valueMap}" property="Parameters"       value="${params}" />
        <mercury:container value="${valueMap}" title="${value.Title}" detailView="${false}" />
    </c:when>
    <c:when test="${variant eq 'area-one-row'}">
        <%-- la_00001 --%>
        <c:set var="bgImage" value="${setting.bgImage.toLink.link}" />
        <c:set var="bgSpacing" value="${setting.bgSpacing.isSetNotNone ? setting.bgSpacing.toString : null}" />
        <c:set var="bgColor" value="${setting.bgColor.isSetNotNone ? setting.bgColor.toString : null}" />

        <c:if test="${not empty bgImage}">
             <c:set var="styleAttr">background-image: url('${bgImage}');</c:set>
             <c:set var="cssWrapper">${cssWrapper}${' '}effect-parallax-bg</c:set>
        </c:if>
        <c:if test="${not empty bgSpacing}">
             <c:set var="cssWrapper">${cssWrapper}${' '}${bgSpacing}</c:set>
        </c:if>
        <c:if test="${not empty bgColor}">
            <c:choose>
                <c:when test="${fn:startsWith(bgColor, '#')}">
                    <c:set var="styleAttr">${styleAttr}${' '}background-color: ${bgColor};</c:set>
                    <c:set var="cssWrapper">${cssWrapper}${' '}colored-row</c:set>
                </c:when>
                <c:otherwise>
                    <c:set var="cssWrapper">${cssWrapper}${' '}colored-row${' '}${bgColor}</c:set>
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${not empty styleAttr}">
              <c:set var="styleAttr"> style="${styleAttr}"</c:set>
        </c:if>
        <main class="area-content ${variant}${empty cssWrapper ? '' : ' '.concat(cssWrapper)}"${styleAttr}>
            <%-- Since the cssWrapper has been manipulated, it is required to add the ' ' prefix again. --%>
            <c:set target="${valueMap}" property="Type"             value="row" />
            <c:set target="${valueMap}" property="Name"             value="main" />
            <c:set target="${valueMap}" property="Tag"              value="div" />
            <c:set target="${valueMap}" property="Css"              value="container area-wide" />
            <mercury:container value="${valueMap}" title="${value.Title}" />
        </main>
    </c:when>
    <c:when test="${(variant eq 'area-side-main') or (variant eq 'area-main-side')}">
        <%-- la_00002 / la_00003 --%>
        <c:set var="asideFirst"                 value="${variant eq 'area-side-main'}" />
        <c:set var="asideWide"                  value="${'true' eq cms.readAttributeOrProperty[cms.requestContext.uri]['mercury.side.wide']}" />
        <c:set var="asideOnTop"                 value="${setting.asideOnTop.toBoolean}" />
        <main class="area-content ${variant}${cssWrapper}"><%----%>
            <div class="container"><%----%>
                <div class="row"><%----%>
                    <c:set target="${valueMap}" property="Type"             value="row" />
                    <c:set target="${valueMap}" property="Name"             value="main" />
                    <c:set target="${valueMap}" property="Tag"              value="div" />
                    <c:set target="${valueMap}" property="Css"              value="col-lg-${asideWide ? '8' : '9'}${asideOnTop ? ' order-last' : ''}${asideFirst ? ' order-lg-last ' : ' '}area-wide" />
                    <mercury:container value="${valueMap}" title="${value.Title}" />
                    <c:set target="${valueMap}" property="Type"             value="element, side-group"/>
                    <c:set target="${valueMap}" property="Name"             value="aside"/>
                    <c:set target="${valueMap}" property="Tag"              value="aside" />
                    <c:set target="${valueMap}" property="Css"              value="col-lg-${asideWide ? '4' : '3'}${asideOnTop ? ' order-first'.concat(asideFirst ? '' : ' order-lg-last') : ''}${asideFirst ? ' order-lg-first ' : ' '}area-narrow" />
                    <mercury:container value="${valueMap}" title="${value.Title}" />
                    <mercury:nl />
                </div><%----%>
            </div><%----%>
        </main><%----%>
    </c:when>
    <c:when test="${variant eq 'area-full-row'}">
        <%-- la_00004 --%>
        <c:set target="${valueMap}" property="Type"             value="element" />
        <c:set target="${valueMap}" property="Name"             value="main" />
        <c:set target="${valueMap}" property="Tag"              value="div" />
        <c:set target="${valueMap}" property="Css"              value="area-content area-wide ${variant}${cssWrapper}" />
        <c:set target="${valueMap}" property="Parameters"       value="${{'cssgrid': 'fullwidth'}}" />
        <mercury:container value="${valueMap}" title="${value.Title}" />
    </c:when>
    <c:otherwise>
        <fmt:setLocale value="${cms.workplaceLocale}" />
        <cms:bundle basename="alkacon.mercury.template.messages">
            <mercury:alert type="error">
                <jsp:attribute name="head">
                    <fmt:message key="msg.error.layout.selection">
                        <fmt:param>${variant}</fmt:param>
                        <fmt:param>${value.Title}</fmt:param>
                    </fmt:message>
                </jsp:attribute>
                <jsp:attribute name="text">
                    <c:out value="${content.filename}" />
                </jsp:attribute>
            </mercury:alert>
        </cms:bundle>
    </c:otherwise>
</c:choose>
<mercury:nl />

<mercury:container-box label="${value.Title}" boxType="model-end" />

</mercury:setting-defaults>

</cms:formatter>

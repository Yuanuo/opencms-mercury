<%@ tag pageEncoding="UTF-8"
    display-name="teaser-settings"
    body-content="scriptless"
    trimDirectiveWhitespaces="true"
    description="Collects default element settings." %>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>


<%@ variable name-given="setting"                   declare="true" variable-class="java.util.Map" %>
<%@ variable name-given="setCssWrapper"             declare="true" %>
<%@ variable name-given="setCssWrapper2"            declare="true" %>
<%@ variable name-given="setCssWrapper3"            declare="true" %>
<%@ variable name-given="setCssWrapperKeyPiece"     declare="true" %>
<%@ variable name-given="setCssWrapperParagraphs"   declare="true" %>
<%@ variable name-given="setCssWrapperExtra"        declare="true" %>
<%@ variable name-given="setEffect"                 declare="true" %>
<%@ variable name-given="setCssVisibility"          declare="true" %>

<%@ variable name-given="setCssWrapper12"           declare="true" %>
<%@ variable name-given="setCssWrapper123"          declare="true" %>
<%@ variable name-given="setCssWrapperAll"          declare="true" %>

<c:set var="setting"                                value="${cms.element.setting}" />
<c:set var="setCssWrapper"                          value="${setting.cssWrapper.isSetNotNone ? ' '.concat(setting.cssWrapper.toString) : null}" />
<c:set var="setCssWrapper2"                         value="${setting.cssWrapper2.isSetNotNone ? ' '.concat(setting.cssWrapper2.toString) : null}" />
<c:set var="setCssWrapper3"                         value="${setting.cssWrapper3.isSetNotNone ? ' '.concat(setting.cssWrapper3.toString) : null}" />
<c:set var="setCssWrapperKeyPiece"                  value="${setting.cssWrapperKeyPiece.isSetNotNone ? ' '.concat(setting.cssWrapperKeyPiece.toString) : null}" />
<c:set var="setCssWrapperParagraphs"                value="${setting.cssWrapperParagraphs.isSetNotNone ? ' paragraph '.concat(setting.cssWrapperParagraphs.toString) : ' paragraph'}" />
<c:set var="setCssWrapperExtra"                     value="${setting.cssWrapperExtra.isSetNotNone  ? ' '.concat(setting.cssWrapperExtra.toString) : null}" />
<c:set var="setEffect"                              value="${setting.effect.isSetNotNone ? ' '.concat(setting.effect.toString) : null}" />
<c:set var="setCssVisibility"                       value="${(setting.cssVisibility.isSetNotNone and (setting.cssVisibility.toString ne 'always')) ? ' '.concat(setting.cssVisibility.toString) : null}" />

<c:if test="${fn:contains(setCssWrapper, '@')}">
    <c:set var="cssWrappers" value="${fn:split(setCssWrapper, '@')}" />
    <c:forEach var="cssWrapper" items="${cssWrappers}" varStatus="status">
        <c:choose>
            <c:when test="${fn:startsWith(cssWrapper, 'kp=')}">
                <c:set var="cssWrapper"             value="${fn:trim(fn:substringAfter(cssWrapper, 'kp='))}" />
                <c:set var="setCssWrapperKeyPiece"  value="${setCssWrapperKeyPiece}${' '}${cssWrapper}" />
            </c:when>
            <c:when test="${fn:startsWith(cssWrapper, 'pa=')}">
                <c:set var="cssWrapper"             value="${fn:trim(fn:substringAfter(cssWrapper, 'pa='))}" />
                <c:set var="setCssWrapperParagraphs" value="${setCssWrapperParagraphs}${' '}${cssWrapper}" />
            </c:when>
            <c:when test="${fn:startsWith(cssWrapper, 'ex=')}">
                <c:set var="cssWrapper"             value="${fn:trim(fn:substringAfter(cssWrapper, 'ex='))}" />
                <c:set var="setCssWrapperExtra"     value="${setCssWrapperExtra}${' '}${cssWrapper}" />
            </c:when>
            <c:otherwise>
                <c:set var="setCssWrapper"          value="${' '}${fn:trim(cssWrapper)}" />
            </c:otherwise>
        </c:choose>
    </c:forEach>
</c:if>

<c:set var="setCssWrapper12"                        value="${setCssWrapper}${setCssWrapper2}" />
<c:set var="setCssWrapper123"                       value="${setCssWrapper12}${setCssWrapper3}" />
<c:set var="setCssWrapperAll"                       value="${setCssWrapper123}${setEffect}${setCssVisibility}" />

<jsp:doBody/>

<%@page
    pageEncoding="UTF-8"
    buffer="none"
    session="false"
    trimDirectiveWhitespaces="true"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>


<cms:secureparams />
<mercury:init-messages reload="true">
<fmt:setLocale value="${cms.locale}"/>
<cms:bundle basename="alkacon.mercury.template.messages">
<mercury:setting-defaults>

<c:set var="hsize"                  value="${setting.hsize.toInteger}" />
<c:set var="pieceLayout"            value="${setting.pieceLayout.toInteger}" />

<c:set var="showOrganization"       value="${setting.showOrganization.toBoolean or (setting.showOrganization.toString eq 'link')}" />
<c:set var="showOrganizationLink"   value="${showOrganization and (setting.showOrganization.toString eq 'link')}" />
<c:set var="showPosition"           value="${setting.showPosition.toBoolean}" />
<c:set var="showAddress"            value="${setting.showAddress.toString eq 'true'}" />
<c:set var="showAddressAlways"      value="${setting.showAddress.toString eq 'always'}" />
<c:set var="showTitle"              value="${setting.showTitle.toBoolean}" />
<c:set var="showDescription"        value="${setting.showDescription.toBoolean}" />
<c:set var="showPhone"              value="${setting.showPhone.toBoolean}" />
<c:set var="showWebsite"            value="${setting.showWebsite.toBoolean}" />
<c:set var="showEmail"              value="${setting.showEmail.toBoolean}" />
<c:set var="showVcard"              value="${setting.showVcard.toBoolean}" />

<c:set var="showImageZoom"          value="${setting.showImageZoom.toBoolean}" />
<c:set var="showImageCopyright"     value="${setting.showImageCopyright.toBoolean}" />
<c:set var="imageRatio"             value="${setting.imageRatio.toString}" />

<c:set var="setSizeDesktop"         value="${setting.pieceSizeDesktop.toInteger}" />
<c:set var="setSizeMobile"          value="${setting.pieceSizeMobile.toInteger}" />

<c:set var="labelOption"            value="${setting.labels.toString}" />
<c:set var="linkOption"             value="${setting.linkOption.toString}" />

<c:set var="containerType"          value="${setting.containerType.useDefault('element').toString}" />

<c:set var="compactLayout"          value="${setting.compactLayout.toBoolean ? ' compact ' : ''}" />

<c:set var="hsizeTitle"             value="${hsize}" />

<c:set var="contactId" value="${param.contactid}" />
<c:if test="${not empty contactId}">
    <c:catch var="exception">
        <c:set var="uid" value="${cms:convertUUID(contactId)}" />
        <c:set var="content" value="${cms.vfs.xml[uid]}" />
        <c:set var="value" value="${content.value}" />
    </c:catch>
</c:if>


<c:choose>
<c:when test="${not empty exception or empty content}">

<div class="subelement">
    <c:choose>
        <c:when test="${cms.isEditMode}">
            <mercury:alert type="warning">
                <jsp:attribute name="head">
                    <fmt:message key="function.contact"/>
                </jsp:attribute>
                <jsp:attribute name="text">
                    <fmt:message key="function.contact.help"/>
                </jsp:attribute>
            </mercury:alert>
        </c:when>
        <c:otherwise>
            <mercury:alert-online>
                <jsp:attribute name="head">
                    <fmt:message key="msg.page.contact.notfound.exception.head"/>
                </jsp:attribute>
                <jsp:attribute name="text">
                    <fmt:message key="msg.page.contact.notfound.exception.text"/>
                </jsp:attribute>
            </mercury:alert-online>
        </c:otherwise>
    </c:choose>
</div>

</c:when>
<c:otherwise>

<mercury:contact-vars
    content="${content}"
    showPosition="${showPosition}"
    showOrganization="${showOrganization}">

<c:set var="showImage"              value="${(imageRatio ne 'no-img') and value.Image.value.Image.isSet}" />
<c:set var="hsize"                  value="${showTitle and value.Title.isSet ? hsize + 1 : hsize}" />
<c:set var="cssWrappers"            value="element type-contact ${kindModern ? null : kindCss}${compactLayout}${setCssWrapperAll}" />

<c:if test="${kindModern}">
<mercury:nl />
<div class="${cssWrappers}"><%----%>
</c:if>

<mercury:nl />
<mercury:section-piece
    cssWrapper="paragraph ${kindModern ? kindCss : cssWrappers}"
    pieceLayout="${pieceLayout}"
    heading="${showTitle ? value.Title : null}"
    hsize="${hsizeTitle}"
    sizeDesktop="${setSizeDesktop}"
    sizeMobile="${setSizeMobile}"
    ade="${false}">

    <jsp:attribute name="markupVisual">
        <c:if test="${showImage}">
            <mercury:contact
                kind="${valKind}"
                link="${value.Link}"
                linkOption="${linkOption eq 'imageOverlay' ? 'imageOverlay' : ''}"
                name="${valKind eq 'org' ? null : valName}"
                organization="${valOrganization}"
                hsize="${hsize}"
                image="${value.Image}"
                imageRatio="${imageRatio}"
                showImage="${true}"
                showImageZoom="${showImageZoom}"
                showImageCopyright="${showImageCopyright}"
            />
        </c:if>
    </jsp:attribute>

    <jsp:attribute name="markupText">
        <mercury:contact
            kind="${valKind}"
            link="${value.Link}"
            linkOption="${linkOption}"
            name="${valName}"
            position="${valPosition}"
            organization="${valOrganization}"
            description="${value.Description}"
            data="${value.Contact}"
            address="${valAddress}"
            labelOption="${labelOption}"
            linkToRelated="${showOrganizationLink ? valLinkToRelated : null}"
            hsize="${hsize}"
            showName="${setShowName}"
            showPosition="${setShowPosition}"
            showAddress="${showAddress}"
            showAddressAlways="${showAddressAlways}"
            showOrganization="${setShowOrganization}"
            showDescription="${showDescription}"
            showPhone="${showPhone}"
            showWebsite="${showWebsite}"
            showEmail="${showEmail}"
            showVcard="${showVcard}"
        />
    </jsp:attribute>

</mercury:section-piece>

<c:if test="${kindModern}">
    </div><%----%>
</c:if>

</mercury:contact-vars>

</c:otherwise>
</c:choose>


</mercury:setting-defaults>
</cms:bundle>
</mercury:init-messages>

<%@tag pageEncoding="UTF-8"
    display-name="container-box"
    body-content="empty"
    trimDirectiveWhitespaces="true"
    description="Generates a configured content container." %>


<%@attribute name="title" type="java.lang.String" required="true"
        description="The title of the content type this container belongs to. This is only used in the placeholder box in edit mode." %>

<%@attribute name="grid" type="java.lang.String" required="false"
        description="The grid information for the container." %>

<%@attribute name="nameprefix" type="java.lang.String" required="false"
        description="Name prefix for the container." %>

<%@attribute name="detailView" type="java.lang.Boolean" required="false"
        description="Indicates if this is the detail view container." %>

<%@attribute name="detailOnly" type="java.lang.Boolean" required="false"
        description="Indicates if this is a detail only attachment container." %>

<%@attribute name="name" type="java.lang.String" required="false"
        description="Name for the container." %>

<%@attribute name="type" type="java.lang.String" required="false"
        description="Type for the container." %>

<%@attribute name="role" type="java.lang.String" required="false"
        description="Role for the container." %>

<%@attribute name="css" type="java.lang.String" required="false"
        description="CSS for the container." %>

<%@attribute name="tag" type="java.lang.String" required="false"
        description="HTML tag for the container." %>

<%@attribute name="value" type="java.util.Map" required="false"
        description="Map that contains the container configuration.
        Can be used instead providing the parameters like 'name', 'type', 'css', 'tag' or 'parameters' direclty." %>

<%@attribute name="settings" type="java.util.Map" required="false"
        description="Setting presets to use with the container." %>

<%@attribute name="parameters" type="java.util.Map" required="false"
        description="Parameters to use with the container." %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>

<c:set var="name"           value="${empty name ? (not empty value.Name ? value.Name.toString() : null) : name}" />
<c:set var="type"           value="${empty type ? (not empty value.Type ? value.Type.toString() : null) : type}" />
<c:set var="role"           value="${empty role ? (not empty value.Role ? value.Role.toString() : null) : role}" />
<c:set var="css"            value="${empty css ? (not empty value.Css ? value.Css.toString() : null) : css}" />
<c:set var="tag"            value="${empty tag ? (not empty value.Tag ? value.Tag.toString() : null) : tag}" />
<c:set var="count"          value="${not empty value.Count and not empty value.Count.toString() ? value.Count.toString() : '100'}" />
<c:set var="preMarkup"      value="${not empty value.PreMarkup ? value.PreMarkup.toString() : null}" />
<c:set var="postMarkup"     value="${not empty value.PostMarkup ? value.PostMarkup.toString() : null}" />
<c:set var="parameters"     value="${empty parameters ? (not empty value.Parameters ? value.Parameters : null) : parameters}" />

<c:set var="variant"        value="${cms:isWrapper(value.Name) ? 'complex' : 'simple'}" />
<c:set var="parent_role"    value="${cms.container.param}" />

<mercury:nl />
<c:if test="${not empty preMarkup}">${preMarkup}</c:if>

<c:choose>

    <c:when test="${showDetailOnly}">
        <%--
            If the container is shown only on detail pages, the container tag later would
            not generate any output on a page that is not a detail page.
            Therefore we insert a placeholder in this case.
        --%>
        <div class="${css}"><%----%>
            <mercury:container-box
                label="${title}${not empty name ? ' - '.concat(name) : ''}"
                boxType="detail-placeholder"
                cssWrapper="attachment"
                type="${type}"
            />
        </div>
    </c:when>

    <c:when test="${count != '0'}">
        <%--
            Generate the container tag.
        --%>
        <c:choose>
            <c:when test="${(role == 'ROLE.DEVELOPER') or (parent_role == 'ROLE.DEVELOPER')}">
                <c:set var="role" value="ROLE.DEVELOPER" />
            </c:when>
            <c:when test="${(role == 'ROLE.EDITOR') or (parent_role == 'ROLE.EDITOR')}">
                <c:set var="role" value="ROLE.EDITOR" />
            </c:when>
            <c:otherwise>
                <c:set var="role" value="ROLE.ELEMENT_AUTHOR" />
            </c:otherwise>
        </c:choose>

        <c:set var="cssGrid" value="${css}" />
        <c:if test="${not empty parameters}" >
            <c:if test="${cms:isWrapper(parameters)}">
                <c:set var="parameters" value="${parameters.toParameters}" />
            </c:if>
            <c:set var="gridParam" value="${parameters['cssgrid']}" />
            <%-- Merge CSS of container with manually passed cssgrid parameter --%>
            <c:if test="${not empty gridParam}">
                <c:set var="cssGrid" value="${cssGrid}${' '}${gridParam}" />
            </c:if>
        </c:if>

        <cms:container
            name="${name}"
            type="${type}"
            tag="${tag}"
            settings="${settings}"
            tagClass="${css}"
            nameprefix="${nameprefix}"
            maxElements="${count}"
            detailview="${detailView}"
            detailonly="${detailOnly}"
            editableby="${role}"
            param="${role}">

            <c:forEach var="entry" items="${parameters}">
                <cms:param name="${entry.key}"  value="${entry.value}" />
            </c:forEach>
            <%-- Overwrite cssgrid after the loop with merged value --%>
            <cms:param name="cssgrid"  value="${cssGrid}" />

            <mercury:container-box
                cssWrapper="${variant}"
                label="${title}${not empty name ? ' - '.concat(name) : ''}"
                boxType="container-box"
                role="${role}"
                type="${type}"
                detailView="${detailView}" />

        </cms:container>
    </c:when>

    <c:otherwise>
        <%--
            The number of elements this container accepts is zero.
            No container is generated, but the layout grid DIV element is written.
            This can be required for layout purposes, e.g. empty placeholders.
        --%>
        <div class="${css}"></div><%----%>
    </c:otherwise>

</c:choose>

<c:if test="${not empty postMarkup}">${postMarkup}</c:if>

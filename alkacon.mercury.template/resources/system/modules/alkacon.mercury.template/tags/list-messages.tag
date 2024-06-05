<%@ tag pageEncoding="UTF-8"
    display-name="list-messages"
    body-content="empty"
    trimDirectiveWhitespaces="true"
    description="Displays the 'empty' list message and other messages used for the list." %>


<%@ attribute name="types" type="java.util.List" required="true"
    description="The resoure types to create, i.e. a list of type names." %>

<%@ attribute name="uploadFolder" type="java.lang.String" required="true"
    description="The upload folder to use for binary files." %>

<%@ attribute name="search" type="org.opencms.jsp.search.result.I_CmsSearchResultWrapper" required="true"
    description="The search result data that was generated by the search tag."%>

<%@ attribute name="dynamic" type="java.lang.Boolean" required="false"
    description="Flag to indicate if a dynamic list was displayed." %>

<%@ attribute name="reloaded" type="java.lang.Boolean" required="false"
    description="Flag to indicate if a dynamic list was reloaded, i.e. not displayed for the first time." %>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="m" tagdir="/WEB-INF/tags/mercury"%>

<c:choose>
    <c:when test="${(dynamic and reloaded) or ((dynamic or (search.numFound == 0)) and not (cms.isEditMode and (search.numFound == 0)))}">
        <%-- A dynamic list MUST contain a hidden notice box. The notice will be activated by JavaScript if required. --%>
        <%-- If the list was reloaded then we assume there was a filter applied and we don't want to display the "add new" in edit mode. --%>
        <m:alert-online css="list-editbox pivot" attr="${dynamic ? 'style=\"display: none;\"' : null}">
            <jsp:attribute name="text">
                <fmt:message key="msg.page.list.empty.online" />
            </jsp:attribute>
        </m:alert-online>
    </c:when>
    <c:when test="${cms.isEditMode and (search.numFound == 0)}">
        <%-- We are in edit mode and have no results. --%>
        <fmt:setLocale value="${cms.workplaceLocale}" />
        <cms:bundle basename="alkacon.mercury.template.messages">
            <m:list-types var="createTypes" types="${types}" uploadFolder="${uploadFolder}" />
            <c:if test="${not empty createTypes}">
                <m:alert type="warning" css="list-editbox">
                    <jsp:attribute name="head">
                        <fmt:message key="msg.page.list.empty" />
                    </jsp:attribute>
                    <jsp:attribute name="text">
                        <fmt:message key="msg.page.list.newentry.listadd" />
                    </jsp:attribute>
                </m:alert>
            </c:if>
        </cms:bundle>
    </c:when>
</c:choose>
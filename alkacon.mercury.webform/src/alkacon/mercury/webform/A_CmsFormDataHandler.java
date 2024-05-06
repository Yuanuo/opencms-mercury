/*
 * This library is part of OpenCms -
 * the Open Source Content Management System
 *
 * Copyright (c) Alkacon Software GmbH & Co. KG (http://www.alkacon.com)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * For further information about Alkacon Software, please see the
 * company website: http://www.alkacon.com
 *
 * For further information about OpenCms, please see the
 * project website: http://www.opencms.org
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package alkacon.mercury.webform;

import org.opencms.db.CmsResourceState;
import org.opencms.file.CmsObject;
import org.opencms.file.CmsResource;
import org.opencms.file.CmsResourceFilter;
import org.opencms.file.types.I_CmsResourceType;
import org.opencms.jsp.CmsJspActionElement;
import org.opencms.lock.CmsLockUtil;
import org.opencms.main.CmsException;
import org.opencms.main.CmsLog;
import org.opencms.main.OpenCms;
import org.opencms.util.CmsUUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

import org.apache.commons.logging.Log;

/**
 * Action class for form data handlers.
 */
public abstract class A_CmsFormDataHandler extends CmsJspActionElement {

    /** The log object for this class. */
    private static final Log LOG = CmsLog.getLog(A_CmsFormDataHandler.class);

    /** A message key. */
    protected final static String ERROR_RESOURCE_NOT_FOUND = "msg.page.bookingmanage.error.resourcenotfound";

    /** A message key. */
    protected final static String ERROR_INTERNAL = "msg.page.bookingmanage.error.internal";

    /** A message key. */
    protected final static String ERROR_LOCKING_FAILED = "msg.page.bookingmanage.error.lockingfailed";

    /** A message key. */
    protected final static String ERROR_FORBIDDEN = "msg.page.bookingmanage.error.forbidden";

    /** A message key. */
    protected final static String ERROR_PUBLISHING_FAILED = "msg.page.bookingmanage.error.publishingfailed";

    /** A message key. */
    protected final static String INFO_SUCCESS_DELETED_SUBMISSION = "msg.page.bookingmanage.info.successdeletesubmission";

    /** Contains error information for the manager. */
    protected String m_error;

    /** Contains information for the manager. */
    protected String m_info;

    /**
     * Creates a new form data handler.
     * @param context the page context
     * @param request the request
     * @param response the response
     */
    protected A_CmsFormDataHandler(PageContext context, HttpServletRequest request, HttpServletResponse response) {

        super(context, request, response);
    }

    /**
     * Returns the error message.
     * @return the error message
     */
    public String getError() {

        return m_error;
    }

    /**
     * Returns the info message.
     * @return the info message
     */
    public String getInfo() {

        return m_info;
    }

    /**
     * Deletes a submission and optionally publishes the deleted resource.
     * @param paramUuid the UUID of the form data content
     * @param publish whether to publish the form data content
     * @return whether deleting the submission was successful
     */
    protected boolean deleteSubmission(String paramUuid, boolean publish) {

        if (getCmsObject().getRequestContext().getCurrentProject().isOnlineProject()) {
            return false;
        }
        CmsObject clone = null;
        try {
            clone = OpenCms.initCmsObject(getCmsObject());
            CmsResource resource = readResource(clone, paramUuid);
            if (resource == null) {
                setError(ERROR_RESOURCE_NOT_FOUND);
                return false;
            }
            I_CmsResourceType resourceType = OpenCms.getResourceManager().getResourceType(resource);
            I_CmsResourceType formDataType = OpenCms.getResourceManager().getResourceType(
                CmsFormUgcConfiguration.CONTENT_TYPE_FORM_DATA);
            if (!resourceType.equals(formDataType)) {
                setError(ERROR_FORBIDDEN);
                return false;
            }
            boolean locked = lockResource(clone, resource);
            if (!locked) {
                setError(ERROR_LOCKING_FAILED);
                return false;
            }
            clone.deleteResource(resource, CmsResource.DELETE_REMOVE_SIBLINGS);
            if (publish) {
                boolean published = publishResource(clone, clone.getSitePath(resource));
                if (!published) {
                    setError(ERROR_PUBLISHING_FAILED);
                    return false;
                }
            }
            setInfo(INFO_SUCCESS_DELETED_SUBMISSION);
        } catch (CmsException e) {
            setError(ERROR_INTERNAL);
            LOG.error(e.getLocalizedMessage(), e);
            return false;
        }
        return true;
    }

    /**
     * Ensures that the form data resource is locked.
     * @param clone the CMS clone
     * @param resource the resource
     * @return whether the form data resource was successfully locked
     */
    protected boolean lockResource(CmsObject clone, CmsResource resource) {

        try {
            CmsLockUtil.ensureLock(clone, resource);
            return true;
        } catch (CmsException e) {
            LOG.error(e.getLocalizedMessage(), e);
            return false;
        }
    }

    /**
     * Publishes a resource.
     * @param clone the CMS clone
     * @param resourceName the resource name
     * @return whether the resource was successfully published
     */
    protected boolean publishResource(CmsObject clone, String resourceName) {

        try {
            OpenCms.getPublishManager().publishResource(clone, resourceName);
            return true;
        } catch (Exception e) {
            LOG.error(e.getLocalizedMessage(), e);
            return false;
        }
    }

    /**
     * Checks whether the form data content exists and is not deleted.
     * @param clone the CMS clone
     * @param paramUuid the UUID of the form data content
     * @return whether the form data content exists and is not deleted
     */
    protected CmsResource readResource(CmsObject clone, String paramUuid) {

        CmsUUID uuid = new CmsUUID(paramUuid);
        if (!clone.existsResource(uuid, CmsResourceFilter.ALL)) {
            return null;
        }
        CmsResource resource = null;
        try {
            resource = clone.readResource(uuid, CmsResourceFilter.ALL);
            if (resource.getState() == CmsResourceState.STATE_DELETED) {
                return null;
            }
        } catch (CmsException e) {
            LOG.error(e.getLocalizedMessage(), e);
            return null;
        }
        return resource;
    }

    /**
     * Sets the error message.
     * @param key the error key
     */
    protected void setError(String key) {

        m_error = key;
    }

    /**
     * Sets the info message.
     * @param key the info key
     */
    protected void setInfo(String key) {

        m_info = key;
    }
}

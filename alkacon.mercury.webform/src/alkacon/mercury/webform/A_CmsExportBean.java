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

import alkacon.mercury.template.writer.A_CmsWriter;

import org.opencms.file.CmsObject;
import org.opencms.file.CmsResource;
import org.opencms.i18n.CmsMessages;
import org.opencms.jsp.util.A_CmsJspCustomContextBean;
import org.opencms.jsp.util.CmsJspContentAccessBean;
import org.opencms.jsp.util.CmsJspContentAccessValueWrapper;
import org.opencms.main.CmsException;
import org.opencms.main.CmsLog;
import org.opencms.main.OpenCms;
import org.opencms.util.CmsStringUtil;
import org.opencms.widgets.serialdate.CmsSerialDateValue;
import org.opencms.xml.I_CmsXmlDocument;
import org.opencms.xml.content.CmsXmlContentFactory;
import org.opencms.xml.types.I_CmsXmlContentValue;

import java.text.DateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.logging.Log;

/**
 * Class representing an export bean for data submitted by a form.
 */
public abstract class A_CmsExportBean extends A_CmsJspCustomContextBean {

    /** Logger instance for this class. */
    private static final Log LOG = CmsLog.getLog(A_CmsExportBean.class);

    /** The bundle with the localization keys. */
    protected static final String BUNDLE_NAME = "alkacon.mercury.template.messages";

    /** Constant for message key. */
    protected static final String KEY_HEADLINE_1 = "msg.page.form.bookingstatus.headline.1";

    /** Constant for message key. */
    protected static final String KEY_EXPORT_DATE_0 = "msg.page.form.bookingstatus.export.date";

    /** Constant for message key. */
    protected static final String KEY_SUBMISSIONS_LABEL = "msg.page.form.bookingstatus.submissions.label";

    /** Constant for message key. */
    protected static final String KEY_SUBMISSIONS_STATUS_3 = "msg.page.form.bookingstatus.submissions.status.3";

    /** Constant for message key. */
    protected static final String KEY_PLACES_LABEL = "msg.page.form.bookingstatus.places.label";

    /** Constant for message key. */
    protected static final String KEY_PLACES_LABEL_UNLIMITED = "msg.page.form.bookingstatus.places.unlimited";

    /** Constant for message key. */
    protected static final String KEY_MAXSUBMISSIONS_NOWAITLIST_1 = "msg.page.form.bookingstatus.maxsubmission.nowaitlist.1";

    /** Constant for message key. */
    protected static final String KEY_MAXSUBMISSIONS_WAITLIST_2 = "msg.page.form.bookingstatus.maxsubmission.waitlist.2";

    /** Constant for message key. */
    protected static final String KEY_FREEPLACES_LABEL = "msg.page.form.bookingstatus.freeplaces.label";

    /** Constant for message key. */
    protected static final String KEY_FULLYBOOKED = "msg.page.form.bookingstatus.fullybooked";

    /** Constant for message key. */
    protected static final String KEY_ONLYWAITLIST_1 = "msg.page.form.bookingstatus.onlywaitlist.1";

    /** Constant for message key. */
    protected static final String KEY_REMAININGSUBMISSIONS_NOWAITLIST_0 = "msg.page.form.remaining.places";

    /** Constant for message key. */
    protected static final String KEY_REMAININGSUBMISSIONS_NOWAITLIST_1 = "msg.page.form.bookingstatus.remainingsubmissions.nowaitlist.1";

    /** Constant for message key. */
    protected static final String KEY_REMAININGSUBMISSIONS_WAITLIST_2 = "msg.page.form.bookingstatus.remainingsubmissions.waitlist.2";

    /** Constant for message key. */
    protected static final String KEY_SUBMISSIONDATA_HEADING = "msg.page.form.bookingstatus.submissiondata.heading";

    /** Constant for message key. */
    protected static final String KEY_STATUS = "msg.page.form.status.submission";

    /** Constant for message key. */
    protected static final String KEY_STATUS_CANCELLED = "msg.page.form.status.submission.cancelled";

    /** Constant for message key. */
    protected static final String KEY_STATUS_WAITLIST = "msg.page.form.status.submission.waitlist";

    /** Constant for message key. */
    protected static final String KEY_STATUS_CONFIRMED = "msg.page.form.status.submission.confirmed";

    /** Constant for message key. */
    protected static final String KEY_STATUS_MOVEDUP = "msg.page.form.status.submission.movedup";

    /** Constant for message key. */
    protected static final String KEY_STATUS_REGISTERED = "msg.page.form.status.submission.registered";

    /** Constant for message key. */
    //protected static final String KEY_STATUS_MAILED = "msg.page.form.status.submission.mailed";

    /** Constant for message key. */
    protected static final String KEY_STATUS_CHANGED = "msg.page.form.status.submission.changed";

    /** Constant for message key. */
    protected static final String KEY_DATE_REGISTERED = "msg.page.form.date.submission.registered";

    /** Constant for message key. */
    protected static final String KEY_DATE_STATUSCHANGED = "msg.page.form.date.submission.statuschanged";

    /** Constant for message key. */
    protected static final String KEY_EVENTDATA_HEADLINE = "msg.page.form.bookingstatus.eventdata.headline";

    /** Constant for message key. */
    protected static final String KEY_BOOKINGDATA_HEADLINE = "msg.page.form.bookingstatus.bookingdata.headline";

    /** Constant for message key. */
    protected static final String KEY_EVENTDATA_TITLE = "msg.page.form.bookingstatus.eventdata.title";

    /** Constant for message key. */
    protected static final String KEY_EVENTDATA_LOCATION = "msg.page.form.bookingstatus.eventdata.location";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_STREETADDRESS = "label.StreetAddress";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_EXTENDEDADDRESS = "label.ExtendedAddress";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_POSTALCODE = "label.PostalCode";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_LOCALITY = "label.Locality";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_REGION = "label.Region";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_COUNTRY = "label.Country";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_COORD = "label.Poi.Coord";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_DATE = "label.Date";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_FINALREGISTRATION = "label.Booking.FinalRegistrationDate";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_PERFORMER = "label.Event.Performer";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_COSTS = "label.Costs";

    /** Constant for message key. */
    protected static final String KEY_EVENTDETAIL_NOTE = "label.Note";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT = "DBExport";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_ADD_FIELD = "AddField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_ADD_SYSTEM_FIELD = "AddSystemField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_CONFIG_FIELD = "ConfigField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_CONFIG_EVENT_INFORMATION = "ConfigEventInformation";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_CONFIG_OVERVIEW_INFORMATION = "ConfigOverviewInformation";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_CONFIG_CANCELLED = "ConfigCancelled";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_IGNORE_FIELD = "IgnoreField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_IGNORE_INPUT_FIELD = "IgnoreInputField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_IGNORE_DEPENDENT_FIELD = "IgnoreDependentField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_IGNORE_FORMER_FIELD = "IgnoreFormerField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_RENAME_FIELD = "RenameField";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_RENAME_FIELD_ORIG = "RenameFieldOrig";

    /** Configuration node name for the value. */
    public static final String NODE_EXPORT_RENAME_FIELD_NEW = "RenameFieldNew";

    /** Constant for configuration option. */
    public static final String OPTION_CANCELLED_SELECTED = "cancelled";

    /** Constant for configuration option. */
    public static final String OPTION_CONFIRMED_SELECTED = "confirmed";

    /** Constant for configuration option. */
    public static final String OPTION_CHANGED_SELECTED = "changed";

    /** Constant for configuration option. */
    public static final String OPTION_WAITLIST_SELECTED = "waitlist";

    /** Export a field with information about whether a registration was cancelled in the meantime. */
    private boolean m_exportConfigAddCancelled = false;

    /** Export a field with information about whether a submission was changed after submission. */
    private boolean m_exportConfigAddChanged = false;

    /** Export a field with information about whether a confirmation mail was sent. */
    private boolean m_exportConfigAddConfirmed = false;

    /** Export a field with information about whether a waitlist notification was sent. */
    private boolean m_exportConfigAddWaitlist = false;

    /** List of fields to ignore during export. */
    private List<String> m_exportConfigFieldIgnore = new ArrayList<String>();

    /** List of fields to rename or merge during export. */
    private Map<String, String> m_exportConfigFieldRename = new HashMap<String, String>();

    /** Flag indicating whether to export event information. */
    private boolean m_exportConfigEventInformation = true;

    /** Flag indicating whether to export overview information. */
    private boolean m_exportConfigOverviewInformation = true;

    /** Flag indicating whether to export the cancelled submissions. */
    private boolean m_exportConfigCancelled = false;

    /** The form to export submissions for. */
    protected CmsFormBean m_form;

    /** Map containing event location data. */
    protected Map<String, String> m_locData;

    /** The event content. */
    protected CmsJspContentAccessBean m_eventContent;

    /** The list of form-data IDs to export. */
    protected List<String> m_formdataIds;

    /** The form's title. */
    protected String m_formTitle;

    /** The message bundle to get the localizations from - already open for the correct locale. */
    protected CmsMessages m_messages;

    /**
     * Exports the submission data and returns the writer holding the data.
     * @return the writer
     */
    abstract public A_CmsWriter export();

    /**
     * Returns a safe file name optimized for file download.
     * @return the optimized file name
     */
    abstract public String getSafeFileName();

    /**
     * Returns a safe export file name with no suffix.
     * @return the export file name
     */
    public String getSafeFileNameNoSuffix() {

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String formatted = formatter.format(now);
        String safeFileName = OpenCms.getResourceManager().getFileTranslator().translateResource(m_formTitle);
        return safeFileName + "-" + formatted;
    }

    /**
     * Initializes this export bean.
     * @param form the form to export data for.
     * @param formTitle the form title to print in the export.
     * @param locData map containing location information
     * @param eventContent event content bean
     * @param locale the locale to export the data in.
     */
    public void init(
        CmsFormBean form,
        String formTitle,
        Map<String, String> locData,
        CmsJspContentAccessBean eventContent,
        Locale locale) {

        init(form, formTitle, locData, eventContent, locale, null);
    }

    /**
     * Initializes this export bean.
     * @param form the form to export data for.
     * @param formTitle the form title to print in the export.
     * @param locData map containing location information
     * @param eventContent event content bean
     * @param locale the locale to export the data in.
     * @param formdataIds comma separated list of form-data IDs to export
     */
    public void init(
        CmsFormBean form,
        String formTitle,
        Map<String, String> locData,
        CmsJspContentAccessBean eventContent,
        Locale locale,
        String formdataIds) {

        m_form = form;
        m_formTitle = formTitle;
        m_messages = new CmsMessages(BUNDLE_NAME, locale);
        m_locData = locData;
        m_eventContent = eventContent;
        if (CmsStringUtil.isNotEmptyOrWhitespaceOnly(formdataIds)) {
            if (formdataIds.contains(",")) {
                m_formdataIds = Arrays.asList(formdataIds.split(","));
            } else {
                m_formdataIds = new ArrayList<String>();
                m_formdataIds.add(formdataIds);
            }
        }
        initExportConfigConfig(locale);
        initExportConfigAdd(locale);
        initExportConfigFieldIgnore(locale);
        initExportConfigFieldRename(locale);
    }

    /**
     * Generates the String value to put in the table instead of the boolean value provided.
     * @param b the value to convert to a String.
     * @return the value as it is printed in the table output.
     */
    protected String asString(boolean b) {

        return b ? "X" : "-";
    }

    /**
     * Collects all actual and former data keys from a collection of stored form submissions and
     * transforms the collected data keys into a ordered map with the column names as the keys
     * of the map and the position as the value. Adds system fields if configured.
     * @param formDataBeans the form data beans
     * @return the column name / position map.
     */
    protected Map<String, Integer> collectColumnNames(List<CmsFormDataBean> formDataBeans) {

        Map<String, Integer> columnNames = new LinkedHashMap<String, Integer>();
        for (CmsFormDataBean formDataBean : formDataBeans) {
            for (String field : formDataBean.getData().keySet()) {
                if (m_exportConfigFieldIgnore.contains(field)) {
                    continue;
                }
                if (m_exportConfigFieldRename.containsKey(field)) {
                    field = m_exportConfigFieldRename.get(field);
                }
                if (!columnNames.containsKey(field)) {
                    columnNames.put(field, Integer.valueOf(columnNames.size()));
                }
            }
        }
        columnNames.put(m_messages.key(KEY_STATUS), Integer.valueOf(columnNames.size()));
        columnNames.put(m_messages.key(KEY_DATE_REGISTERED), Integer.valueOf(columnNames.size()));
        columnNames.put(m_messages.key(KEY_DATE_STATUSCHANGED), Integer.valueOf(columnNames.size()));
        if (m_exportConfigAddCancelled) {
            columnNames.put(m_messages.key(KEY_STATUS_CANCELLED), Integer.valueOf(columnNames.size()));
        }
        if (m_exportConfigAddWaitlist) {
            columnNames.put(m_messages.key(KEY_STATUS_WAITLIST), Integer.valueOf(columnNames.size()));
        }
        if (m_exportConfigAddConfirmed) {
            columnNames.put(m_messages.key(KEY_STATUS_CONFIRMED), Integer.valueOf(columnNames.size()));
        }
        if (m_exportConfigAddChanged) {
            columnNames.put(m_messages.key(KEY_STATUS_CHANGED), Integer.valueOf(columnNames.size()));
        }
        return columnNames;
    }

    /**
     * Reads all submissions, transforms the submissions according to given configurations
     * and writes the the transformed data to the export file writer.
     * @param writer the writer
     * @return the export file writer.
     */
    protected A_CmsWriter export(A_CmsWriter writer) {

        writeEventInformation(writer);
        writeOverviewInformation(writer);
        writeData(writer);
        return writer;
    }

    /**
     * Returns the data of one submission as a map. May include inactive former columns.
     * Filters fields to ignore. Renames and merges fields according to the export configuration.
     * Adds system fields if configured.
     * @param formData the submission data as bean.
     * @return the submission data as map.
     */
    protected Map<String, String> getData(CmsFormDataBean formData) {

        Map<String, String> data = formData.getData();
        Iterator<Map.Entry<String, String>> iter = data.entrySet().iterator();
        Map<String, String> merged = new LinkedHashMap<String, String>();
        while (iter.hasNext()) {
            Map.Entry<String, String> entry = iter.next();
            String key = entry.getKey();
            String value = entry.getValue();
            if (m_exportConfigFieldIgnore.contains(key)) {
                continue;
            }
            if (m_exportConfigFieldRename.containsKey(key)) {
                key = m_exportConfigFieldRename.get(key);
            }
            if (merged.containsKey(key)) {
                String merge = merged.get(key);
                if (!CmsStringUtil.isEmptyOrWhitespaceOnly(value)) {
                    merge += " " + value;
                }
                merged.put(key, merge);
            } else {
                merged.put(key, value);
            }
        }
        if (formData.isWaitlistMovedUp()) {
            merged.put(m_messages.key(KEY_STATUS), m_messages.key(KEY_STATUS_MOVEDUP));
        } else if (formData.isWaitlist()) {
            merged.put(m_messages.key(KEY_STATUS), m_messages.key(KEY_STATUS_WAITLIST));
        } else if (formData.isCancelled()) {
            merged.put(m_messages.key(KEY_STATUS), m_messages.key(KEY_STATUS_CANCELLED));
        } else {
            merged.put(m_messages.key(KEY_STATUS), m_messages.key(KEY_STATUS_REGISTERED));
        }
        merged.put(
            m_messages.key(KEY_DATE_REGISTERED),
            m_messages.getDateTime(formData.getDateRegistered(), DateFormat.SHORT));
        if (formData.getDateCancelled() != null) {
            merged.put(
                m_messages.key(KEY_DATE_STATUSCHANGED),
                m_messages.getDateTime(formData.getDateCancelled(), DateFormat.SHORT));
        } else if (formData.getDateMovedUp() != null) {
            merged.put(
                m_messages.key(KEY_DATE_STATUSCHANGED),
                m_messages.getDateTime(formData.getDateMovedUp(), DateFormat.SHORT));
        } else {
            merged.put(m_messages.key(KEY_DATE_STATUSCHANGED), "");
        }
        if (m_exportConfigAddCancelled) {
            merged.put(m_messages.key(KEY_STATUS_CANCELLED), asString(formData.isCancelled()));
        }
        if (m_exportConfigAddWaitlist) {
            merged.put(m_messages.key(KEY_STATUS_WAITLIST), asString(formData.isWaitlist()));
        }
        if (m_exportConfigAddConfirmed) {
            merged.put(m_messages.key(KEY_STATUS_CONFIRMED), asString(formData.isConfirmationMailSent()));
        }
        if (m_exportConfigAddChanged) {
            merged.put(m_messages.key(KEY_STATUS_CHANGED), asString(formData.isChanged()));
        }
        return merged;
    }

    /**
     * Reads all form submissions from the database and returns the data as a list of form data beans.
     * If configuration option cancelled is set to false, cancelled submissions are not added to the list.
     * @return the list of form data beans
     */
    protected List<CmsFormDataBean> readFormDataBeans() {

        CmsObject cms = getCmsObject();
        List<CmsFormDataBean> formDataBeans = new ArrayList<CmsFormDataBean>();
        List<CmsResource> submissions = m_form.getSubmissions();
        if (m_formdataIds != null) {
            List<CmsResource> filtered = new ArrayList<CmsResource>();
            for (CmsResource submission : submissions) {
                if (m_formdataIds.contains(submission.getStructureId().toString())) {
                    filtered.add(submission);
                }
            }
            submissions = filtered;
        }
        for (CmsResource submission : submissions) {
            try {
                I_CmsXmlDocument formDataXml;
                formDataXml = CmsXmlContentFactory.unmarshal(cms, cms.readFile(submission));
                CmsFormDataBean formDataBean = new CmsFormDataBean(formDataXml);
                if (!m_exportConfigCancelled) {
                    formDataBeans.add(formDataBean);
                } else if (!formDataBean.isCancelled()) {
                    formDataBeans.add(formDataBean);
                }
            } catch (CmsException e) {
                LOG.warn(
                    "Failed to read submission data from " + submission.getRootPath() + " when exporting the data.",
                    e);
            }
        }
        return formDataBeans;
    }

    /**
     * Writes the submission data to the export file writer.
     * @param writer the export file writer
     */
    protected void writeData(A_CmsWriter writer) {

        List<CmsFormDataBean> formDataBeans = readFormDataBeans();
        Collections.reverse(formDataBeans);
        writer.addTable(collectColumnNames(formDataBeans));
        for (CmsFormDataBean formDataBean : formDataBeans) {
            writer.addTableRow(getData(formDataBean));
        }
    }

    /**
     * Reads the system fields to add configuration from the form content.
     * @param locale the locale
     */
    private void initExportConfigAdd(Locale locale) {

        CmsObject cms = getCmsObject();
        String pathPrefix = NODE_EXPORT + "/" + NODE_EXPORT_ADD_FIELD;
        I_CmsXmlDocument formConfig = m_form.getFormConfig();
        if (formConfig.hasValue(NODE_EXPORT, locale) && formConfig.hasValue(pathPrefix, locale)) {
            pathPrefix = pathPrefix + "/" + NODE_EXPORT_ADD_SYSTEM_FIELD;
            int numAddSystemFields = m_form.getFormConfig().getIndexCount(pathPrefix, locale);
            for (int i = 1; i <= numAddSystemFields; i++) {
                String pathAddSystemField = pathPrefix + "[" + i + "]/";
                String addSystemField = m_form.getFormConfig().getValue(pathAddSystemField, locale).getStringValue(cms);
                if (addSystemField.equals(OPTION_CANCELLED_SELECTED)) {
                    m_exportConfigAddCancelled = true;
                } else if (addSystemField.equals(OPTION_CHANGED_SELECTED)) {
                    m_exportConfigAddChanged = true;
                } else if (addSystemField.equals(OPTION_CONFIRMED_SELECTED)) {
                    m_exportConfigAddConfirmed = true;
                } else if (addSystemField.equals(OPTION_WAITLIST_SELECTED)) {
                    m_exportConfigAddWaitlist = true;
                }
            }
        }
    }

    /**
     * Reads the overview information configuration from the form content.
     * @param locale the locale
     */
    private void initExportConfigConfig(Locale locale) {

        CmsObject cms = getCmsObject();
        String pathPrefix = NODE_EXPORT + "/" + NODE_EXPORT_CONFIG_FIELD;
        I_CmsXmlDocument formConfig = m_form.getFormConfig();
        if (formConfig.hasValue(NODE_EXPORT, locale) && formConfig.hasValue(pathPrefix, locale)) {
            String prefixEventInformation = pathPrefix + "/" + NODE_EXPORT_CONFIG_EVENT_INFORMATION;
            if (formConfig.hasValue(prefixEventInformation, locale)) {
                String configEventInformation = formConfig.getValue(prefixEventInformation, locale).getStringValue(cms);
                m_exportConfigEventInformation = Boolean.valueOf(configEventInformation).booleanValue();
            } else {
                m_exportConfigEventInformation = true;
            }
            String prefixOverviewInformation = pathPrefix + "/" + NODE_EXPORT_CONFIG_OVERVIEW_INFORMATION;
            String configOverviewInformation = formConfig.getValue(prefixOverviewInformation, locale).getStringValue(
                cms);
            m_exportConfigOverviewInformation = Boolean.valueOf(configOverviewInformation).booleanValue();
            String prefixCancelled = pathPrefix + "/" + NODE_EXPORT_CONFIG_CANCELLED;
            String configCancelled = m_form.getFormConfig().getValue(prefixCancelled, locale).getStringValue(cms);
            m_exportConfigCancelled = Boolean.valueOf(configCancelled).booleanValue();
        }
    }

    /**
     * Reads the ignore field export configuration from the form content.
     * @param locale the locale
     */
    private void initExportConfigFieldIgnore(Locale locale) {

        CmsObject cms = getCmsObject();
        if (m_form.getFormConfig().hasValue(NODE_EXPORT, locale)) {
            String pathPrefix = NODE_EXPORT + "/" + NODE_EXPORT_IGNORE_FIELD;
            if (m_form.getFormConfig().hasValue(pathPrefix, locale)) {
                String pathIgnoreInputField = pathPrefix + "/" + NODE_EXPORT_IGNORE_INPUT_FIELD;
                String pathIgnoreDependentField = pathPrefix + "/" + NODE_EXPORT_IGNORE_DEPENDENT_FIELD;
                String pathIgnoreFormerField = pathPrefix + "/" + NODE_EXPORT_IGNORE_FORMER_FIELD;
                List<I_CmsXmlContentValue> values = new ArrayList<I_CmsXmlContentValue>();
                values.addAll(m_form.getFormConfig().getValues(pathIgnoreInputField, locale));
                values.addAll(m_form.getFormConfig().getValues(pathIgnoreDependentField, locale));
                values.addAll(m_form.getFormConfig().getValues(pathIgnoreFormerField, locale));
                for (I_CmsXmlContentValue value : values) {
                    m_exportConfigFieldIgnore.add(value.getStringValue(cms));
                }
            }
        }
    }

    /**
     * Reads the rename field export configuration from the form content.
     * @param locale the locale
     */
    private void initExportConfigFieldRename(Locale locale) {

        CmsObject cms = getCmsObject();
        if (m_form.getFormConfig().hasValue(NODE_EXPORT, locale)) {
            String pathPrefix = NODE_EXPORT + "/" + NODE_EXPORT_RENAME_FIELD;
            int numRenameFields = m_form.getFormConfig().getIndexCount(pathPrefix, locale);
            for (int i = 1; i <= numRenameFields; i++) {
                String pathRenameFieldOrig = pathPrefix + "[" + i + "]/" + NODE_EXPORT_RENAME_FIELD_ORIG;
                String pathRenameFieldNew = pathPrefix + "[" + i + "]/" + NODE_EXPORT_RENAME_FIELD_NEW;
                String renameFieldOrig = m_form.getFormConfig().getValue(pathRenameFieldOrig, locale).getStringValue(
                    cms);
                String renameFieldNew = m_form.getFormConfig().getValue(pathRenameFieldNew, locale).getStringValue(cms);
                m_exportConfigFieldRename.put(renameFieldOrig, renameFieldNew);
            }
        }
    }

    /**
     * Writes event information to the export file writer.
     * @param writer the export file writer
     */
    private void writeEventInformation(A_CmsWriter writer) {

        if (!m_exportConfigEventInformation || (m_eventContent == null)) {
            return;
        }
        writeHeadline(writer);
        writer.addRowHeadline(m_messages.key(KEY_EVENTDATA_HEADLINE));
        String titleValue = m_eventContent.getValue().get("Title").getToString();
        writer.addRow(m_messages.key(KEY_EVENTDATA_TITLE), titleValue);
        writer.addRow(m_messages.key(KEY_EVENTDATA_LOCATION), m_locData.get("name"));
        writer.addRow(m_messages.key(KEY_EVENTDETAIL_STREETADDRESS), m_locData.get("streetAddress"));
        if (CmsStringUtil.isNotEmptyOrWhitespaceOnly(m_locData.get("extendedAddress"))) {
            writer.addRow(m_messages.key(KEY_EVENTDETAIL_EXTENDEDADDRESS), m_locData.get("extendedAddress"));
        }
        String postalCode = m_locData.get("postalCode") != null ? m_locData.get("postalCode") + " " : "";
        writer.addRow(
            m_messages.key(KEY_EVENTDETAIL_POSTALCODE) + "/" + m_messages.key(KEY_EVENTDETAIL_LOCALITY),
            postalCode + m_locData.get("locality"));
        if (CmsStringUtil.isNotEmptyOrWhitespaceOnly(m_locData.get("region"))) {
            writer.addRow(m_messages.key(KEY_EVENTDETAIL_REGION), m_locData.get("region"));
        }
        if (CmsStringUtil.isNotEmptyOrWhitespaceOnly(m_locData.get("country"))) {
            writer.addRow(m_messages.key(KEY_EVENTDETAIL_COUNTRY), m_locData.get("country"));
        }
        if ((m_locData.get("lat") != null) && (m_locData.get("lng") != null)) {
            String coords = m_locData.get("lat") + "," + m_locData.get("lng");
            writer.addRow(m_messages.key(KEY_EVENTDETAIL_COORD), coords);
        }
        if (m_eventContent.getValue().get("Dates") != null) {
            CmsSerialDateValue serialDateValue = new CmsSerialDateValue(
                m_eventContent.getValue().get("Dates").getToString());
            String startDate = m_messages.getDateTime(serialDateValue.getStart(), DateFormat.SHORT);
            String endDate = null;
            if (serialDateValue.getEnd() != null) {
                endDate = m_messages.getDateTime(serialDateValue.getEnd(), DateFormat.SHORT);
                String dateValue = startDate + " - " + endDate;
                writer.addRow(m_messages.key(KEY_EVENTDETAIL_DATE), dateValue);
            } else {
                writer.addRow(m_messages.key(KEY_EVENTDETAIL_DATE), startDate);
            }
        }
        CmsJspContentAccessValueWrapper booking = m_eventContent.getValue().get("Booking");
        if ((booking != null) && (booking.getValue().get("FinalRegistrationDate") != null)) {
            String finalRegistrationDate = m_messages.getDateTime(
                booking.getValue().get("FinalRegistrationDate").getToDate(),
                DateFormat.SHORT);
            writer.addRow(m_messages.key(KEY_EVENTDETAIL_FINALREGISTRATION), finalRegistrationDate);
        }
        CmsJspContentAccessValueWrapper performerValue = m_eventContent.getValue().get("Performer");
        String performer = performerValue != null ? performerValue.getToString() : "";
        writer.addRow(m_messages.key(KEY_EVENTDETAIL_PERFORMER), performer);
        if (m_eventContent.getValueList().get("Costs") != null) {
            for (CmsJspContentAccessValueWrapper costsValue : m_eventContent.getValueList().get("Costs")) {
                try {
                    String label = costsValue.getValue().get("Label").getToString();
                    String price = costsValue.getValue().get("Price").getToString();
                    String currency = costsValue.getValue().get("Currency").getToString();
                    writer.addRow(m_messages.key(KEY_EVENTDETAIL_COSTS), label + ": " + currency + " " + price);
                } catch (IllegalArgumentException e) {
                    writer.addRow(m_messages.key(KEY_EVENTDETAIL_COSTS), "");
                }
            }
        }
        if (m_eventContent.getValueList().get("Note") != null) {
            for (CmsJspContentAccessValueWrapper noteValue : m_eventContent.getValueList().get("Note")) {
                CmsJspContentAccessValueWrapper noteTitleValue = noteValue.getValue().get("Title");
                String noteTitle = noteTitleValue != null ? noteTitleValue.getToString() : "";
                for (CmsJspContentAccessValueWrapper noteTextValue : noteValue.getValueList().get("Text")) {
                    String noteText = noteTextValue != null ? noteTextValue.getToString() : "";
                    writer.addRow(m_messages.key(KEY_EVENTDETAIL_NOTE), noteTitle + ": " + noteText);
                }
            }
        }
        writer.addRow();
    }

    /**
     * Writes the headline to the export file writer.
     * @param writer the export file writer
     */
    private void writeHeadline(A_CmsWriter writer) {

        writer.addRowHeadline(m_messages.key(KEY_HEADLINE_1, m_formTitle));
        writer.addRow(m_messages.key(KEY_EXPORT_DATE_0), m_messages.getDateTime(new Date(), DateFormat.SHORT));
        writer.addRow();
    }

    /**
     * Writes the booking overview information to the export file writer.
     * @param writer the export file writer
     */
    private void writeOverviewInformation(A_CmsWriter writer) {

        if (!m_exportConfigOverviewInformation) {
            return;
        }
        if (!m_exportConfigEventInformation) {
            writeHeadline(writer);
        }
        writer.addRowHeadline(m_messages.key(KEY_BOOKINGDATA_HEADLINE));
        CmsSubmissionStatus status = m_form.getSubmissionStatus();
        String submissionsValue = m_messages.key(
            KEY_SUBMISSIONS_STATUS_3,
            Integer.valueOf(status.getNumTotalSubmissions()),
            Integer.valueOf(status.getNumFormSubmissions()),
            Integer.valueOf(status.getNumOtherSubmissions()));
        writer.addRow(m_messages.key(KEY_SUBMISSIONS_LABEL), submissionsValue);
        String placesValue = m_messages.key(
            KEY_MAXSUBMISSIONS_WAITLIST_2,
            status.getMaxRegularSubmissions(),
            Integer.valueOf(status.getMaxWaitlistSubmissions()));
        if (status.getMaxWaitlistSubmissions() == 0) {
            placesValue = m_messages.key(KEY_PLACES_LABEL_UNLIMITED);
        } else if (status.getMaxWaitlistSubmissions() == 0) {
            placesValue = m_messages.key(KEY_MAXSUBMISSIONS_NOWAITLIST_1, status.getMaxRegularSubmissions());
        }
        writer.addRow(m_messages.key(KEY_PLACES_LABEL), placesValue);
        String freeplacesValue = "";
        if (status.isFullyBooked()) {
            freeplacesValue = m_messages.key(KEY_FULLYBOOKED);
        } else if (status.isOnlyWaitlist()) {
            freeplacesValue = m_messages.key(
                KEY_ONLYWAITLIST_1,
                Integer.valueOf(status.getNumRemainingWaitlistSubmissions()));
        } else if (status.getMaxWaitlistSubmissions() == 0) {
            if (status.getNumRemainingRegularSubmissions() == null) {
                freeplacesValue = m_messages.key(KEY_REMAININGSUBMISSIONS_NOWAITLIST_0);
            } else {
                freeplacesValue = m_messages.key(
                    KEY_REMAININGSUBMISSIONS_NOWAITLIST_1,
                    status.getNumRemainingRegularSubmissions());
            }
        } else {
            freeplacesValue = m_messages.key(
                KEY_REMAININGSUBMISSIONS_WAITLIST_2,
                status.getNumRemainingRegularSubmissions(),
                Integer.valueOf(status.getNumRemainingWaitlistSubmissions()));
        }
        writer.addRow(m_messages.key(KEY_FREEPLACES_LABEL), freeplacesValue);
        writer.addRow();
        writer.addRowHeadline(m_messages.key(KEY_SUBMISSIONDATA_HEADING));
    }
}

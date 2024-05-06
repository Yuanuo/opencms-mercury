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

package alkacon.mercury.template;

import org.opencms.util.CmsStringUtil;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Provides convenient functions to calculate the with of bootstrap columns.<p>
 *
 * Supports bootstrap 5, i.e. works with XS, SM, MD, LG, XL and XXL column sizes.
 *
 */
public class CmsJspBootstrapBean {

    /** The CSS string this bootstrap bean was initialized with. */
    private String m_css;

    /** The array of parent CSS classes. */
    private String[] m_cssArray;

    /** The bootstrap gutter size. */
    private int m_gutter = 30;

    /** Indicates if this bootstrap bean was initialized with at least one column. */
    private boolean m_initialized;

    /** Maximum number of columns for the bootstrap grid. */
    private int m_maxCols = 12;

    /** The calculated grid columns width in percent (initial value is 100% for all). */
    protected double[] m_column = {100.0D, 100.0D, 100.0D, 100.0D, 100.0D, 100.0D};

    /** The grid container width in pixel. */
    // Note: This is set to the Mercury default "$container-max-widths" values (which are different from standard Bootstrap 5)
    // For XS there is no "min-width", so we set the target size to 375 pixel which is the iPhone 6 display width
    protected int[] m_gridSize = {375, 540, 744, 992, 1170, 1320};

    /** public empty constructor for use on JSP.<p> */
    public CmsJspBootstrapBean() {

        // NOOP
    }

    /**
     * Add a new layer of grid information.<p>
     *
     * @param gridCols an array that holds the grid column width information
     */
    public void addLayer(int[] gridCols) {

        m_initialized = true;
        double maxCols = Integer.valueOf(m_maxCols).doubleValue();
        for (int i = 0; i < m_column.length; i++) {
            m_column[i] *= gridCols[i] / maxCols;
        }
    }

    /**
     * Add a new layer of grid information.<p>
     *
     * @param gridCss the CSS that holds the grid column width information
     *
     * @return <code>true</code> if the layer contained grid classes relevant for the size calculation
     */
    public boolean addLayer(String gridCss) {

        int xs = -1;
        int sm = -1;
        int md = -1;
        int lg = -1;
        int xl = -1;
        int xxl = -1;
        boolean hideXs = false;
        boolean hideSm = false;
        boolean hideMd = false;
        boolean hideLg = false;
        boolean hideXl = false;
        boolean hideXxl = false;

        String[] items = gridCss.toLowerCase().split("\\s+");
        for (String i : items) {
            if (i.startsWith("col-") || i.startsWith("tile-") || i.startsWith("square-") || i.startsWith("p-")) {
                String iSub = i.substring(i.indexOf('-'));
                if (iSub.startsWith("-xs-")) {
                    xs = parseCol(i);
                } else if (iSub.startsWith("-sm-")) {
                    sm = parseCol(i);
                } else if (iSub.startsWith("-md-")) {
                    md = parseCol(i);
                } else if (iSub.startsWith("-lg-")) {
                    lg = parseCol(i);
                } else if (iSub.startsWith("-xl-")) {
                    xl = parseCol(i);
                } else if (iSub.startsWith("-xxl-")) {
                    xxl = parseCol(i);
                } else if (iSub.startsWith("-")) {
                    // BS 5 uses 'col-4' instead of 'col-xs-4' so we fall back to XS in case all others don't match
                    xs = parseCol(i);
                }
            } else if (i.startsWith("hidden-")) {
                String iSub = i.substring(7);
                if (iSub.startsWith("xs")) {
                    hideXs = true;
                } else if (iSub.startsWith("sm")) {
                    hideSm = true;
                } else if (iSub.startsWith("md")) {
                    hideMd = true;
                } else if (iSub.startsWith("lg")) {
                    hideLg = true;
                } else if (iSub.startsWith("xl")) {
                    hideXl = true;
                } else if (iSub.startsWith("xxl")) {
                    hideXxl = true;
                }
            }
        }

        int last = m_maxCols;
        int xsCols = hideXs ? 0 : (xs < 0) ? last : xs;
        last = (xs < 0) ? last : xs;
        int smCols = hideSm ? 0 : (sm < 0) ? last : sm;
        last = (sm < 0) ? last : sm;
        int mdCols = hideMd ? 0 : (md < 0) ? last : md;
        last = (md < 0) ? last : md;
        int lgCols = hideLg ? 0 : (lg < 0) ? last : lg;
        last = (lg < 0) ? last : lg;
        int xlCols = hideXl ? 0 : (xl < 0) ? last : xl;
        last = (xl < 0) ? last : xl;
        int xxlCols = hideXxl ? 0 : (xxl < 0) ? last : xxl;
        last = (xxl < 0) ? last : xxl;

        boolean newLayer = (last != m_maxCols) || hideXs || hideSm || hideMd || hideLg || hideXl || hideXxl;
        newLayer = newLayer || (xs > -1) || (sm > -1) || (md > -1) || (lg > -1) || (xl > -1) || (xxl > -1);
        if (newLayer) {
            int[] result = {xsCols, smCols, mdCols, lgCols, xlCols, xxlCols};
            addLayer(result);
        }
        return newLayer;
    }

    /**
     * Returns the CSS this bean was initialized width.<p>
     *
     * @return the CSS this bean was initialized width
     */
    public String getCss() {

        if ((m_css == null) && (m_cssArray != null)) {
            StringBuffer result = new StringBuffer(128);
            for (int i = 0; i < m_cssArray.length; i++) {
                if (i > 0) {
                    result.append(':');
                }
                result.append(m_cssArray[i]);
            }
            m_css = result.toString();
        }
        return m_css;
    }

    /**
     * Returns the array of parent CSS classes.<p>
     *
     * @return the array of parent CSS classes
     */
    public String[] getCssArray() {

        return m_cssArray;
    }

    /**
     * Returns the pixel size of a grid column.<p>
     *
     * The index must be between 0 (XS) and 5 (XXL).<p>
     *
     * @param gridIndex the grid index to get the size for
     *
     * @return the pixel size of a grid column
     */
    public int getGridSize(int gridIndex) {

        return m_gridSize[gridIndex];
    }

    /**
     * Returns the gutter size this bean was initialized width.<p>
     *
     * @return the gutter size this bean was initialized width
     */
    public int getGutter() {

        return m_gutter;
    }

    /**
     * Returns <code>true</code> if this bootstrap bean has calculated grid information.<p>
     *
     * @return <code>true</code> if this bootstrap bean has calculated grid information
     */
    public boolean getIsInitialized() {

        return m_initialized;
    }

    /**
     * Returns the column pixel width calculated for the LG screen size.<p>
     *
     * @return the column pixel width calculated for the LG screen size
     */
    public int getSizeLg() {

        return getSize(3);
    }

    /**
     * Checks all available sizes from the <code>getSizeXX</code> methods and returns the maximum value larger.<p>
     *
     * If all grid sizes are zero then zero is returned.<p>
     *
     * @return the calculated maximum grid size
     */
    public int getSizeMax() {

        int result = 0;
        for (int i = 0; i < m_column.length; i++) {
            int size = getSize(i);
            if (size > result) {
                result = size;
            }
        }
        return result;
    }

    /**
     * Returns the column pixel width calculated for the MD screen size.<p>
     *
     * @return the column pixel width calculated for the MD screen size
     */
    public int getSizeMd() {

        return getSize(2);
    }

    /**
     * Checks all available sizes from the <code>getSizeXX</code> methods and returns the minimum value larger than zero.<p>
     *
     * Zero grid sizes are ignored. However, if all grid sizes are zero then zero is returned.<p>
     *
     * @return the calculated minimum grid size
     */
    public int getSizeMin() {

        int result = Integer.MAX_VALUE;
        for (int i = 0; i < m_column.length; i++) {
            int size = getSize(i);
            if ((size > 0) && (size < result)) {
                result = size;
            }
        }
        return result < Integer.MAX_VALUE ? result : 0;
    }

    /**
     * Returns the column pixel width calculated for the SM screen size.<p>
     *
     * @return the column pixel width calculated for the SM screen size
     */
    public int getSizeSm() {

        return getSize(1);
    }

    /**
     * Returns the column pixel width calculated for the XL screen size.<p>
     *
     * @return the column pixel width calculated for the XL screen size
     */
    public int getSizeXl() {

        return getSize(4);
    }

    /**
     * Returns the column pixel width calculated for the XS screen size.<p>
     *
     * @return the column pixel width calculated for the XS screen size
     */
    public int getSizeXs() {

        return getSize(0);
    }

    /**
     * Returns the column pixel width calculated for the XXL screen size.<p>
     *
     * @return the column pixel width calculated for the XXL screen size
     */
    public int getSizeXxl() {

        return getSize(5);
    }

    /**
     * Initialize the CSS used for this bootstrap bean.<p>
     *
     * @param css the CSS used for this bootstrap bean
     */
    public void setCss(String css) {

        if (css != null) {
            m_css = css;
            List<String> layers = CmsStringUtil.splitAsList(css, ':', true);
            m_cssArray = new String[layers.size()];
            int last = layers.size();
            for (String layer : layers) {
                addLayer(layer);
                m_cssArray[--last] = layer;
            }
        }
    }

    /**
     * Sets the array of parent CSS classes.<p>
     *
     * @param cssArray the array of parent CSS classes to set
     */
    public void setCssArray(String[] cssArray) {

        if ((cssArray != null) && (cssArray.length > 0)) {
            List<String> result = new ArrayList<>();
            for (String layer : cssArray) {
                if (layer.equals("#")) {
                    // start layer reached, following layers are 'real' get request parameters
                    break;
                } else {
                    if (addLayer(layer)) {
                        result.add(layer);
                    }
                }
            }
            m_cssArray = result.toArray(new String[result.size()]);
        }
    }

    /**
     * Sets the pixel size of a grid column.<p>
     *
     * The index must be between 0 (XS) and 5 (XXL).<p>
     *
     * @param gridIndex the grid index to set the size for
     * @param gridWidth the grid width to set
     */
    public void setGridSize(int gridIndex, int gridWidth) {

        m_gridSize[gridIndex] = gridWidth;
    }

    /**
     * Sets the gutter used in the bootstrap grid.<p>
     *
     * @param gutter the gutter used in the bootstrap grid
     */
    public void setGutter(int gutter) {

        m_gutter = gutter;
    }

    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {

        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        nf.setMaximumFractionDigits(2);
        nf.setMinimumFractionDigits(2);
        return "xs="
            + getSizeXs()
            + "px("
            + nf.format(m_column[0])
            + "%) sm="
            + getSizeSm()
            + "px("
            + nf.format(m_column[1])
            + "%) md="
            + getSizeMd()
            + "px("
            + nf.format(m_column[2])
            + "%) lg="
            + getSizeLg()
            + "px("
            + nf.format(m_column[3])
            + "%) xl="
            + getSizeXl()
            + "px("
            + nf.format(m_column[4])
            + "%) xxl="
            + getSizeXxl()
            + "px("
            + nf.format(m_column[5])
            + "%)";
    }

    /**
     * Calculate the pixel size of a grid column.<p>
     *
     * @param gridIndex the grid index to get the size for
     *
     * @return the pixel size of a grid column
     */
    protected int getSize(int gridIndex) {

        int gridSize = m_gridSize[gridIndex];
        double spaceFactor = m_column[gridIndex];

        int result = (int)Math.ceil((gridSize * spaceFactor) / 100.0);
        result = result > m_gutter ? result - m_gutter : 0;
        return result;
    }

    /**
     * Parses a bootstrap column CSS class like 'col-md-5'.<p>
     *
     * @param colStr the bootstrap column CSS class to parse
     *
     * @return the number part of the CSS class
     */
    protected int parseCol(String colStr) {

        int result;
        String number = colStr.substring(colStr.lastIndexOf('-') + 1);
        try {
            result = Integer.valueOf(number).intValue();
        } catch (NumberFormatException e) {
            result = -1;
        }
        if (result <= 0) {
            result = -1;
        }
        if (result > m_maxCols) {
            result = m_maxCols;
        }
        return result;
    }
}
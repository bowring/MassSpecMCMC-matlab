/*
 * MATLAB Compiler: 8.4 (R2022a)
 * Date: Thu May 26 12:01:27 2022
 * Arguments: 
 * "-B""macro_default""-W""java:magicsquare,magic""-d""./magicsquarejavaPackage""-Z""autodetect""class{magic:/Users/bowring/Development/MassSpecMCMC-matlab/MagicDemoComp/makesqr.m}"
 */

package magicsquare;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;
import java.io.Serializable;
/**
 * <i>INTERNAL USE ONLY</i>
 */
public class MagicsquareMCRFactory implements Serializable 
{
    /** Component's uuid */
    private static final String sComponentId = "magicsquare_cfb84aca-9604-4839-b925-2aaf76ff88d2";
    
    /** Component name */
    private static final String sComponentName = "magicsquare";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(MagicsquareMCRFactory.class)
        );
    
    
    private MagicsquareMCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            MagicsquareMCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{9,12,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}

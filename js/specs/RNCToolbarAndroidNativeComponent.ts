import type { HostComponent, ViewProps } from 'react-native';
import type { ImageSource } from 'react-native/Libraries/Image/ImageSource';
import { DirectEventHandler, WithDefault, Int32 } from 'react-native/Libraries/Types/CodegenTypes';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';

type Action = Readonly<{
    title: string,
    icon?: ImageSource,
    show?: WithDefault<'always' | 'ifRoom' | 'never', 'ifRoom'>,
    showWithText?: boolean
}>;

type ToolbarAndroidChangeEvent = Readonly<{
    position: Int32
}>;

type ColorValue = null | string;

type NativeProps = Readonly<{
    onSelect: DirectEventHandler<ToolbarAndroidChangeEvent>,
    nativeActions?: Array<Action>,
}>;

export interface ToolbarAndroidProps extends ViewProps, NativeProps {
    // 添加其它 props
    actions?: Array<Action>,
    /**
     * Sets the toolbar logo.
     */
    logo?: ImageSource,
    /**
     * Sets the navigation icon.
     */
    navIcon?: ImageSource,
    /**
     * Callback that is called when an action is selected. The only argument that is passed to the
     * callback is the position of the action in the actions array.
     */
    onActionSelected?: DirectEventHandler<ToolbarAndroidChangeEvent>,
    /**
     * Callback called when the icon is selected.
     */
    onIconClicked?: DirectEventHandler<Readonly<{}>>,
    /**
     * Sets the overflow icon.
     */
    overflowIcon?: ImageSource,
    /**
     * Sets the toolbar subtitle.
     */
    subtitle?: string,
    /**
     * Sets the toolbar subtitle color.
     */
    subtitleColor?: ColorValue,
    /**
     * Sets the toolbar title.
     */
    title?: string,
    /**
     * Sets the toolbar title color.
     */
    titleColor?: ColorValue,
    /**
     * Sets the content inset for the toolbar starting edge.
     *
     * The content inset affects the valid area for Toolbar content other than
     * the navigation button and menu. Insets define the minimum margin for
     * these components and can be used to effectively align Toolbar content
     * along well-known gridlines.
     */
    contentInsetStart?: Int32,
    /**
     * Sets the content inset for the toolbar ending edge.
     *
     * The content inset affects the valid area for Toolbar content other than
     * the navigation button and menu. Insets define the minimum margin for
     * these components and can be used to effectively align Toolbar content
     * along well-known gridlines.
     */
    contentInsetEnd?: Int32,
    /**
     * Used to set the toolbar direction to RTL.
     * In addition to this property you need to add
     *
     *   android:supportsRtl="true"
     *
     * to your application AndroidManifest.xml and then call
     * `setLayoutDirection(LayoutDirection.RTL)` in your MainActivity
     * `onCreate` method.
     */
    rtl?: boolean,
    /**
     * Used to locate this view in end-to-end tests.
     */
    testID?: string,
};

// export default codegenNativeComponent<ToolbarAndroidProps>(
//     'ToolbarAndroid',
// ) as HostComponent<ToolbarAndroidProps>;
export default codegenNativeComponent<ToolbarAndroidProps>(
    'ToolbarAndroid',
) as HostComponent<ToolbarAndroidProps>;
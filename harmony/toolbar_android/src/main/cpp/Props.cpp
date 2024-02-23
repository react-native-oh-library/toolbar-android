/**
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "Props.h"
#include <react/renderer/components/image/conversions.h>
#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>

namespace facebook {
namespace react {

ToolbarAndroidProps::ToolbarAndroidProps(
    const PropsParserContext &context,
    const ToolbarAndroidProps &sourceProps,
    const RawProps &rawProps): ViewProps(context, sourceProps, rawProps),

    nativeActions(convertRawProp(context, rawProps, "nativeActions", sourceProps.nativeActions, {})),
    actions(convertRawProp(context, rawProps, "actions", sourceProps.actions, {})),
    logo(convertRawProp(context, rawProps, "logo", sourceProps.logo, {})),
    navIcon(convertRawProp(context, rawProps, "navIcon", sourceProps.navIcon, {})),
    overflowIcon(convertRawProp(context, rawProps, "overflowIcon", sourceProps.overflowIcon, {})),
    subtitle(convertRawProp(context, rawProps, "subtitle", sourceProps.subtitle, {})),
    subtitleColor(convertRawProp(context, rawProps, "subtitleColor", sourceProps.subtitleColor, {})),
    title(convertRawProp(context, rawProps, "title", sourceProps.title, {})),
    titleColor(convertRawProp(context, rawProps, "titleColor", sourceProps.titleColor, {})),
    contentInsetStart(convertRawProp(context, rawProps, "contentInsetStart", sourceProps.contentInsetStart, {0})),
    contentInsetEnd(convertRawProp(context, rawProps, "contentInsetEnd", sourceProps.contentInsetEnd, {0})),
    rtl(convertRawProp(context, rawProps, "rtl", sourceProps.rtl, {false})),
    testID(convertRawProp(context, rawProps, "testID", sourceProps.testID, {}))
      {}

} // namespace react
} // namespace facebook

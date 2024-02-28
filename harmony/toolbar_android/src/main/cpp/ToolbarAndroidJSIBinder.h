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

#include "RNOHCorePackage/ComponentBinders/ViewComponentJSIBinder.h"

namespace rnoh {
class ToolbarAndroidJSIBinder : public ViewComponentJSIBinder {
    facebook::jsi::Object createNativeProps(facebook::jsi::Runtime &rt) override
    {
        auto object = ViewComponentJSIBinder::createNativeProps(rt);
        object.setProperty(rt, "nativeActions", "array");
        object.setProperty(rt, "logo", "ImageSource");
        object.setProperty(rt, "navIcon", "ImageSource");
        object.setProperty(rt, "overflowIcon", "ImageSource");
        object.setProperty(rt, "subtitle", "string");
        object.setProperty(rt, "subtitleColor", "string");
        object.setProperty(rt, "title", "string");
        object.setProperty(rt, "titleColor", "string");
        object.setProperty(rt, "contentInsetStart", "int");
        object.setProperty(rt, "contentInsetEnd", "int");
        object.setProperty(rt, "rtl", "bool");
        return object;
    }

    facebook::jsi::Object createDirectEventTypes(facebook::jsi::Runtime &rt) override
    {
        facebook::jsi::Object events(rt);
        events.setProperty(rt, "topOnSelect", createDirectEvent(rt, "onSelect"));
        return events;
    }
};
} // namespace rnoh
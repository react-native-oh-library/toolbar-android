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

#pragma once

#include <jsi/jsi.h>
#include <react/renderer/components/image/conversions.h>
#include <react/renderer/components/view/ViewProps.h>
#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>
#include <react/renderer/imagemanager/primitives.h>
#include <vector>

namespace facebook {
    namespace react {

        enum class ToolbarAndroidShow { Always, IfRoom, Never };

        static inline void fromRawValue(const PropsParserContext &context, const RawValue &value,
                                        ToolbarAndroidShow &result) {
            auto string = (std::string)value;
            if (string == "always") {
                result = ToolbarAndroidShow::Always;
                return;
            }
            if (string == "ifRoom") {
                result = ToolbarAndroidShow::IfRoom;
                return;
            }
            if (string == "never") {
                result = ToolbarAndroidShow::Never;
                return;
            }
            abort();
        }

        static inline std::string toString(const ToolbarAndroidShow &value) {
            switch (value) {
            case ToolbarAndroidShow::Always:
                return "always";
            case ToolbarAndroidShow::IfRoom:
                return "ifRoom";
            case ToolbarAndroidShow::Never:
                return "never";
            }
        }

        struct ToolbarAndroidNativeActionsStruct {
            std::string title;
            ImageSource icon;
            ToolbarAndroidShow show;
            bool showWithText;
        };

        static inline void fromRawValue(const PropsParserContext &context, const RawValue &value,
                                        ToolbarAndroidNativeActionsStruct &result) {
            auto map = (butter::map<std::string, RawValue>)value;

            auto tmp_title = map.find("title");
            if (tmp_title != map.end()) {
                fromRawValue(context, tmp_title->second, result.title);
            }
            auto tmp_icon = map.find("icon");
            if (tmp_icon != map.end()) {
                fromRawValue(context, tmp_icon->second, result.icon);
            }
            auto tmp_show = map.find("show");
            if (tmp_show != map.end()) {
                fromRawValue(context, tmp_show->second, result.show);
            }
            auto tmp_showWithText = map.find("showWithText");
            if (tmp_showWithText != map.end()) {
                fromRawValue(context, tmp_showWithText->second, result.showWithText);
            }
        }

        static inline std::string toString(const ToolbarAndroidNativeActionsStruct &value) {
            return "[Object ToolbarAndroidNativeActionsStruct]";
        }

        static inline void fromRawValue(const PropsParserContext &context, const RawValue &value,
                                        std::vector<ToolbarAndroidNativeActionsStruct> &result) {
            auto items = (std::vector<RawValue>)value;
            for (const auto &item : items) {
    ToolbarAndroidNativeActionsStruct newItem;
                fromRawValue(context, item, newItem);
                result.emplace_back(newItem);
            }
        }


struct ToolbarAndroidActionsStruct {
  std::string title;
  ImageSource icon;
  ToolbarAndroidShow show;
  bool showWithText;
};

        static inline void fromRawValue(const PropsParserContext &context, const RawValue &value,
                                        ToolbarAndroidActionsStruct &result) {
            auto map = (butter::map<std::string, RawValue>)value;

            auto tmp_title = map.find("title");
            if (tmp_title != map.end()) {
                fromRawValue(context, tmp_title->second, result.title);
            }
            auto tmp_icon = map.find("icon");
            if (tmp_icon != map.end()) {
                fromRawValue(context, tmp_icon->second, result.icon);
            }
            auto tmp_show = map.find("show");
            if (tmp_show != map.end()) {
                fromRawValue(context, tmp_show->second, result.show);
            }
            auto tmp_showWithText = map.find("showWithText");
            if (tmp_showWithText != map.end()) {
                fromRawValue(context, tmp_showWithText->second, result.showWithText);
            }
        }

        static inline std::string toString(const ToolbarAndroidActionsStruct &value) {
            return "[Object ToolbarAndroidActionsStruct]";
        }

        static inline void fromRawValue(const PropsParserContext &context, const RawValue &value,
                                        std::vector<ToolbarAndroidActionsStruct> &result) {
            auto items = (std::vector<RawValue>)value;
            for (const auto &item : items) {
                ToolbarAndroidActionsStruct newItem;
                fromRawValue(context, item, newItem);
                result.emplace_back(newItem);
            }
        }

        class ToolbarAndroidProps final : public ViewProps {
        public:
            ToolbarAndroidProps() = default;
            ToolbarAndroidProps(const PropsParserContext &context, const ToolbarAndroidProps &sourceProps,
                                   const RawProps &rawProps);

#pragma mark - Props

            std::vector<ToolbarAndroidNativeActionsStruct> nativeActions{};
            std::vector<ToolbarAndroidActionsStruct> actions{};
            ImageSource logo{};
            ImageSource navIcon{};
            ImageSource overflowIcon{};
            std::string subtitle{};
            std::string subtitleColor{};
            std::string title{};
            std::string titleColor{};
            int contentInsetStart{0};
            int contentInsetEnd{0};
            bool rtl{false};
            std::string testID{};
        };

    } // namespace react
} // namespace facebook

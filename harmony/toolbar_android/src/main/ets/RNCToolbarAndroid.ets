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

import { Descriptor, ViewBaseProps } from 'rnoh';
import { RNOHContext, RNViewBase } from 'rnoh'
import Logger from './Logger';
import { Toolbar, RNCToolbarAndroidProps } from './Toolbar'

export const RNC_TOOLBAR_ANDROID_TYPE: string = 'ToolbarAndroid'

export interface RNCToolbarAndroidState {}

export type RNCToolbarAndroidDescriptor = Descriptor<'ToolbarAndroid', ViewBaseProps, RNCToolbarAndroidState, RNCToolbarAndroidProps>

@Component
export struct RNCToolbarAndroid {
  ctx!: RNOHContext;
  tag: number = 0;
  @State descriptor: RNCToolbarAndroidDescriptor = {} as RNCToolbarAndroidDescriptor;
  private unregisterDescriptorChangesListener?: () => void = undefined;

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<RNCToolbarAndroidDescriptor>(this.tag);
    this.unregisterDescriptorChangesListener = this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag,
      (newDescriptor) => {
        this.descriptor = (newDescriptor as RNCToolbarAndroidDescriptor)
      }
    )
    Logger.debug(`RNCToolbarAndroid descriptor is: ${JSON.stringify(this.descriptor)}`);
  }

  aboutToDisappear() {
    this.unregisterDescriptorChangesListener?.()
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Toolbar({
        ctx: this.ctx,
        tag: this.tag,
        props: this.descriptor.rawProps,
        layoutSize: this.descriptor.layoutMetrics.frame.size
      })
    }
  }
}
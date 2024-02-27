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

import { image } from '@kit.ImageKit';
import { http } from '@kit.NetworkKit';
import measure from '@ohos.measure';
import ResponseCode from '@ohos.net.http';
import { RNOHContext, Size, ViewRawProps } from 'rnoh'
import { Constants } from './Constants';
import Logger from './Logger';

export interface RNCToolbarAndroidProps extends ViewRawProps {
  logo?: ImageSource,
  navIcon?: ImageSource,
  overflowIcon?: ImageSource,
  title: string,
  titleColor?: string,
  subtitle?: string,
  subtitleColor?: string
  nativeActions?: Array<Action>
  contentInsetStart?: number,
  contentInsetEnd?: number,
  rtl?: boolean
}

interface ImageSource {
  uri: string,
  width: number,
  height: number
}

interface Action {
  title: string,
  icon?: ImageSource,
  show?: string,
  showWithText?: boolean
};

enum ShowAsAction {
  SHOW_AS_ACTION_NEVER = 0,
  SHOW_AS_ACTION_IF_ROOM = 1,
  SHOW_AS_ACTION_ALWAYS = 2,
  SHOW_AS_ACTION_WITH_TEXT = 4
}

class MenuItem {
  value: ResourceStr;
  icon?: ImageSource | undefined;
  action?: () => void;
  showAsAction: ShowAsAction;
  order: number

  constructor(value: ResourceStr, icon: ImageSource | undefined, showAsAction: ShowAsAction, order: number) {
    this.value = value
    this.icon = icon
    this.showAsAction = showAsAction
    this.order = order
  }
}

@Component
export struct Toolbar {
  private ctx!: RNOHContext;
  private tag: number = 0;
  private props: RNCToolbarAndroidProps | undefined = undefined;
  private layoutSize?: Size;
  @State navIcon: ImageSource | undefined = undefined;
  @State navImage: PixelMap | Resource | undefined = undefined;
  @State isTouchNav: boolean = false;
  @State logo: ImageSource | undefined = undefined;
  @State logoImage: PixelMap | Resource | undefined = undefined;
  @State overflowIcon: ImageSource | undefined = undefined;
  @State overflowImage: PixelMap | Resource | undefined = undefined;
  @State isLogoShow: boolean = true;
  @State isTitleShow: boolean = true;
  @State touchActionIndex: number = -1;
  @State isPressAction: boolean = false;
  @State isTouchMore: boolean = false;
  @State isInitFinish: boolean = false;
  @State isShowMenu: boolean = false;
  @State touchMenuIndex: number = -1;
  private title: string = '';
  private titleColor: string | undefined = '';
  private subtitle: string | undefined = '';
  private subtitleColor: string | undefined = '';
  private actions: Array<Action> | undefined = [];
  private showActions: Array<MenuItem> = [];
  private hiddenActions: Array<MenuItem> = [];
  private windowWidth: number = 0;

  aboutToAppear(): void {
    this.getWindowWidth();
    this.initParams();
    this.initAction();
    this.initComponentLayout();
  }

  build() {
    Row() {
      if (this.isInitFinish) {
        // 导航区
        this.NavIcon();

        Row() {
          Row() {
            if (this.logo && this.isLogoShow) {
              Row() {
                Image(this.logoImage)
                  .width(Math.min(this.logo.height, this.logo.width))
                  .height(this.logo.height)
                  .objectFit(ImageFit.Cover)
                  .draggable(false)
              }
              .width(this.logo.width)
              .height(this.logo.height)
              .justifyContent(FlexAlign.Center)
            }
            if (this.isTitleShow) {
              Column() {
                Text(this.title)
                  .fontSize($r('app.float.default_title_font_size'))
                  .fontColor(this.titleColor ? this.titleColor : $r('sys.color.ohos_id_color_text_primary'))
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
                Text(this.subtitle)
                  .fontSize($r('app.float.default_sub_title_font_size'))
                  .fontColor(this.subtitleColor ? this.subtitleColor : $r('sys.color.ohos_id_color_text_primary'))
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .maxLines(1)
              }
              .align(Alignment.Center)
              .alignItems(HorizontalAlign.Start)
              .flexShrink(1)
            }
          }
          .margin({
            left: !this.navIcon ? this.props?.contentInsetStart : 0,
            right: !this.actions ? this.props?.contentInsetEnd : 0
          })
          .flexShrink(1)
          .direction(this.props?.rtl ? Direction.Rtl : Direction.Auto)

          //菜单
          this.ActionMenu();
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .flexShrink(1)
        .direction(this.props?.rtl ? Direction.Rtl : Direction.Auto)
      }
    }
    .width('100%')
    .height(this.props?.height)
    .constraintSize({ minHeight: 56 })
    .justifyContent(FlexAlign.Center)
    .direction(this.props?.rtl ? Direction.Rtl : Direction.Auto)
  }

  @Builder
  NavIcon() {
    if (this.navIcon) {
      Row() {
        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image(this.navImage)
            .width(this.navIcon.width ? this.navIcon.width : Constants.DEFAULT_NAV_ICON_SIZE)
            .height(this.navIcon.height ? this.navIcon.height : Constants.DEFAULT_NAV_ICON_SIZE)
            .objectFit(ImageFit.Fill)
            .draggable(false)
        }
        .backgroundColor(this.isTouchNav ? $r('sys.color.ohos_id_color_tooltip_background') : Color.Transparent)
        .onTouch((event: TouchEvent) => {
          if (event) {
            if (event.type === TouchType.Down) {
              this.isTouchNav = true;
            }
            if (event.type === TouchType.Up) {
              this.isTouchNav = false;
            }
          }
        })
        .onClick(() => {
          this.onIconClicked();
        })
      }
      .constraintSize({ minHeight: 36, minWidth: Constants.DEFAULT_NAV_ICON_SIZE })
      .justifyContent(FlexAlign.Center)
      .flexShrink(0)
      .onClick(() => {
        this.onIconClicked();
      })
    }
  }

  /**
   * 自定义菜单栏组件
   * 有图标显示图标，无图标显示文字。图标尺寸最大为36*36
   */
  @Builder
  ActionMenu() {
    Row() {
      if (this.showActions.length > 0) {
        ForEach(this.showActions, (menu: MenuItem, index: number) => {
          if (menu.icon?.uri) {
            Button({ type: ButtonType.Circle, stateEffect: false }) {
              Image(this.getMediaByName(menu.icon.uri))
                .width(menu.icon.width)
                .height(menu.icon.height)
                .constraintSize({
                  maxWidth: Constants.DEFAULT_MENU_ITEM_SIZE - 4,
                  maxHeight: Constants.DEFAULT_MENU_ITEM_SIZE - 4
                })
                .objectFit(ImageFit.Contain)
                .draggable(false)
            }
            .width(Constants.DEFAULT_MENU_ITEM_SIZE)
            .height(Constants.DEFAULT_MENU_ITEM_SIZE)
            .margin({
              left: index == 0 ? 0 : Constants.DEFAULT_MENU_ITEM_MARGIN,
              right: Constants.DEFAULT_MENU_ITEM_MARGIN
            })
            .backgroundColor(this.touchActionIndex == index ? $r('sys.color.ohos_id_color_tooltip_background') : Color.Transparent)
            .onTouch((event: TouchEvent) => {
              if (event) {
                if (event.type === TouchType.Down) {
                  this.touchActionIndex = index;
                }
                if (event.type === TouchType.Up) {
                  this.touchActionIndex = -1;
                }
              }
            })
            .gesture(
              LongPressGesture({ repeat: false })
                .onAction(() => {
                  this.isPressAction = true;
                })
                .onActionEnd(() => {
                  this.isPressAction = false;
                })
            )
            .onClick(() => {
              menu?.action && menu.action();
            })
            .bindPopup(this.touchActionIndex == index && this.isPressAction, {
              message: menu.value.toString(),
              enableArrow: false,
              targetSpace: 18,
              radius: 4
            })
          } else {
            Text(menu.value)
              .fontSize($r('app.float.default_menu_text_font_size'))
              .onClick(() => {
                menu?.action && menu.action();
              })
          }
        })
      }
      if (this.hiddenActions.length > 0) {
        Button({ type: ButtonType.Circle, stateEffect: false }) {
          Image(this.overflowIcon?.uri ? this.overflowImage : $r('sys.media.ohos_ic_public_more'))
            .width(this.overflowIcon?.width == 0 ? Constants.DEFAULT_MORE_ICON_SIZE : this.overflowIcon?.width)
            .height(this.overflowIcon?.height == 0 ? Constants.DEFAULT_MORE_ICON_SIZE : this.overflowIcon?.height)
            .constraintSize({
              maxWidth: Constants.DEFAULT_MORE_ICON_SIZE,
              maxHeight: Constants.DEFAULT_MORE_ICON_SIZE
            })
            .draggable(false)
        }
        .width(Constants.DEFAULT_MENU_ITEM_SIZE)
        .height(Constants.DEFAULT_MENU_ITEM_SIZE)
        .margin({
          left: Constants.DEFAULT_MENU_ITEM_MARGIN,
          right: Constants.DEFAULT_MENU_ITEM_MARGIN
        })
        .backgroundColor(this.isTouchMore ? $r('sys.color.ohos_id_color_tooltip_background') : Color.Transparent)
        .onTouch((event: TouchEvent) => {
          if (event) {
            if (event.type === TouchType.Down) {
              this.isTouchMore = true;
            }
            if (event.type === TouchType.Up) {
              this.isTouchMore = false;
              this.isShowMenu = true;
            }
          }
        })
        .bindPopup(this.isShowMenu, {
          builder: this.MenuPopup(),
          placement: Placement.RightTop,
          enableArrow: false,
          targetSpace: -36,
          radius: 4
        })
      }
    }
    .direction(this.props?.rtl ? Direction.Rtl : Direction.Auto)
  }

  @Builder
  MenuPopup() {
    List({ space: 8, initialIndex: 0 }) {
      ForEach(this.hiddenActions, (item: MenuItem, index: number) => {
        ListItem() {
          Text(item.value)
            .width('100%')
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .height(48)
        .padding({ left: 12, right: 12 })
        .backgroundColor(this.touchMenuIndex == index ? $r('sys.color.ohos_id_color_tooltip_background') : Color.Transparent)
        .onTouch((event: TouchEvent) => {
          if (event) {
            if (event.type === TouchType.Down) {
              this.touchMenuIndex = index;
            }
            if (event.type === TouchType.Up) {
              this.touchMenuIndex = -1;
              this.isShowMenu = false;
              item?.action && item.action();
            }
          }
        })
      }, (item: string) => item)
    }
    .constraintSize({ maxWidth: px2vp(this.windowWidth * 2 / 3) })
  }

  initParams() {
    if (this.props == null || this.props == undefined) {
      Logger.error('params invalid! props is null');
      return;
    }
    this.title = this.props?.title;
    this.titleColor = this.props?.titleColor;
    this.subtitle = this.props?.subtitle;
    this.subtitleColor = this.props?.subtitleColor;
    this.navIcon = this.props?.navIcon;
    this.logo = this.props?.logo;
    this.overflowIcon = this.props?.overflowIcon;
    this.actions = this.props?.nativeActions;
  }

  initAction() {
    if (this.actions == null || this.actions == undefined || this.actions.length == 0) {
      return;
    }
    for (let i = 0; i < this.actions.length; i++) {
      let action = this.actions[i]
      let menuItem = new MenuItem(action.title, action.icon, this.convertActionShow(action.show), i);
      menuItem.action = () => {
        this.onActionSelected(i)
      };
      if (action.show == 'always' || action.show == 'ifRoom') {
        this.showActions.push(menuItem);
      }
      if (action.show == 'never') {
        this.hiddenActions.push(menuItem);
      }
    }
  }

  initBindMenus() {
    // 按照order排序
    this.hiddenActions.sort((pre, next) => {
      return pre.order - next.order;
    })
  }

  convertActionShow(show: string | undefined): ShowAsAction {
    let showAsAction = ShowAsAction.SHOW_AS_ACTION_IF_ROOM;
    if (show == 'always') {
      showAsAction = ShowAsAction.SHOW_AS_ACTION_ALWAYS;
    }
    if (show == 'ifRoom') {
      showAsAction = ShowAsAction.SHOW_AS_ACTION_IF_ROOM;
    }
    if (show == 'never') {
      showAsAction = ShowAsAction.SHOW_AS_ACTION_NEVER;
    }
    return showAsAction;
  }

  getWindowWidth() {
    let displayWidth = this.layoutSize?.width;
    this.windowWidth = displayWidth == 0 ? Constants.DEFAULT_WINDOW_WIDTH : Math.ceil(vp2px(displayWidth));
    Logger.debug('getWindowWidth :' + this.windowWidth);
  }

  getMenusWidth(): number {
    let actionCount = this.showActions.length;
    let showMenuWidth = vp2px(actionCount * Constants.DEFAULT_MENU_ITEM_SIZE + actionCount * Constants.DEFAULT_MENU_ITEM_MARGIN * 2 - Constants.DEFAULT_MENU_ITEM_MARGIN);
    let moreIconWidth = 0;
    if (this.hiddenActions.length > 0) {
      moreIconWidth = vp2px(Constants.DEFAULT_MORE_ICON_SIZE + Constants.DEFAULT_MENU_ITEM_MARGIN * 2)
    }
    return showMenuWidth + moreIconWidth;
  }

  getTitleWidth(title: string | undefined, textSize: Resource | number): number {
    if (!title) {
      return 0;
    }
    return measure.measureText({ textContent: title, fontSize: textSize })
  }

  getNavWidth() {
    if (this.navIcon?.width) {
      return vp2px(this.navIcon.width > Constants.DEFAULT_NAV_ICON_SIZE ? this.navIcon.width : Constants.DEFAULT_NAV_ICON_SIZE);
    }
    return 0;
  }

  calcComponentWidth(logoWidth: number, titleWidth: number, menusWidth: number) {
    let nacIconWidth = this.getNavWidth();
    Logger.debug('nacIconWidth:' + nacIconWidth + 'logoWidth:' + logoWidth + 'titleWidth:' + titleWidth + 'menusWidth:' + menusWidth);
    if (nacIconWidth + logoWidth + titleWidth + menusWidth < this.windowWidth) {
      return;
    }

    // 空间不够先隐藏ifRoom的菜单,图标较多时至少展示3个
    if (this.showActions.length > 2) {
      for (let i = this.showActions.length - 1; i > 0; i--) {
        if (this.showActions[i].showAsAction != ShowAsAction.SHOW_AS_ACTION_IF_ROOM) {
          continue;
        }
        Logger.debug('There is not enough space, hide ifRoom menu.');
        this.hiddenActions = this.hiddenActions.concat(this.showActions.splice(i, 1));
        this.calcComponentWidth(logoWidth, titleWidth, this.getMenusWidth());
        return;
      }
    }

    // 再隐藏title和logo
    if (titleWidth > this.getTitleWidth(this.title.slice(0, Math.ceil(this.title.length / 3)), $r('app.float.default_title_font_size'))) {
      Logger.debug('There is not enough space, decrease the width of the title.');
      this.calcComponentWidth(logoWidth, titleWidth - vp2px(Constants.DEFAULT_MENU_ITEM_SIZE + Constants.DEFAULT_MENU_ITEM_MARGIN * 2), this.getMenusWidth());
    } else if (titleWidth != 0) {
      Logger.debug('There is not enough space, hide the title.');
      this.isTitleShow = false;
      this.calcComponentWidth(logoWidth, 0, menusWidth);
    } else if (logoWidth > 0) {
      Logger.debug('There is not enough space, decrease the width of the logo.');
      let availableWidth = logoWidth - menusWidth;
      if (this.logo && this.logo.width > 0) {
        this.logo.width = availableWidth > 0 ? px2vp(availableWidth) : this.logo.width;
      }
      this.calcComponentWidth(availableWidth, 0, menusWidth);
    } else {
      Logger.debug('There is not enough space, hide the logo.');
      this.isLogoShow = false;
    }
  }

  onIconClicked(): void {
    this.ctx.rnInstance.emitComponentEvent(
      this.tag,
      Constants.EVENT_NAME,
      {
        type: 'onSelect',
        position: -1
      }
    )
  }

  onActionSelected(position: number): void {
    this.ctx.rnInstance.emitComponentEvent(
      this.tag,
      Constants.EVENT_NAME,
      {
        type: 'onSelect',
        position: position
      }
    )
  }

  async initComponentLayout() {
    await this.initNavImage();
    await this.initLogoImage();
    this.initOverflowImage();
    let logoWidth = this.logo?.width ? this.logo.width : Constants.DEFAULT_LOGO_SIZE;
    this.calcComponentWidth(vp2px(logoWidth), this.getTitleWidth(this.title, $r('app.float.default_title_font_size')), this.getMenusWidth());
    this.initBindMenus();
    this.isInitFinish = true;
  }

  async initNavImage() {
    if (this.navIcon?.uri == undefined) {
      return;
    }
    let uri = this.navIcon.uri;
    if (!this.isLoadedFromServer(uri)) {
      Logger.debug('initNavImage uri is:' + uri);
      this.navImage = this.getMediaByName(uri);
      return;
    }
    let pixelMap = await this.getImageFromServer(uri);
    if (!pixelMap) {
      Logger.info('initNavImage getImageFromServer return undefined.');
      return;
    }
    let imageInfo = await pixelMap.getImageInfo();
    if (this.navIcon && !this.navIcon.width) {
      this.navIcon.width = Math.min(imageInfo.size.width, px2vp(this.windowWidth));
    }
    if (this.navIcon && !this.navIcon.height) {
      let layoutHeight = this.layoutSize?.height ? this.layoutSize.height : 0;
      this.navIcon.height = layoutHeight > 0 && imageInfo.size.height > layoutHeight ? layoutHeight : imageInfo.size.height;
    }
    Logger.debug(`initNavImage size: ${JSON.stringify(this.navIcon)}`);
    this.navImage = pixelMap;
  }

  async initLogoImage() {
    if (!this.logo || this.logo.uri == undefined) {
      this.isLogoShow = false;
      return;
    }
    let layoutHeight = this.layoutSize?.height ? this.layoutSize.height : 0;
    let uri = this.logo.uri;
    if (!this.isLoadedFromServer(uri)) {
      this.logo.width = Math.min(this.logo.width, px2vp(this.windowWidth));
      this.logo.height = this.logo.height > 0 && this.logo.height > layoutHeight ? layoutHeight : this.logo.height;
      this.logoImage = this.getMediaByName(uri);
      return;
    }
    let pixelMap = await this.getImageFromServer(this.logo.uri);
    if (!pixelMap) {
      Logger.error('initLogoImage getImageFromServer return undefined.');
      return;
    }
    let imageInfo = await pixelMap.getImageInfo();
    if (this.logo && !this.logo.width) {
      this.logo.width = Math.min(imageInfo.size.width, px2vp(this.windowWidth));
    }
    if (this.logo && !this.logo.height) {
      this.logo.height = layoutHeight > 0 && imageInfo.size.height > layoutHeight ? layoutHeight : imageInfo.size.height;
    }
    Logger.debug('initLogoImage size: ' + JSON.stringify(this.logo));
    this.logoImage = pixelMap;
  }

  initOverflowImage() {
    if (this.overflowIcon?.uri == undefined) {
      return;
    }
    let layoutHeight = this.layoutSize?.height ? this.layoutSize.height : 0;
    let uri = this.overflowIcon.uri;
    if (!this.isLoadedFromServer(uri)) {
      this.overflowIcon.width = Math.min(this.overflowIcon.width, px2vp(this.windowWidth));
      this.overflowIcon.height = this.overflowIcon.height > 0 && this.overflowIcon.height > layoutHeight ? layoutHeight : this.overflowIcon.height;
      this.overflowImage = this.getMediaByName(uri);
      return;
    }
    this.getImageFromServer(this.overflowIcon.uri).then((image) => {
      if (!image) {
        Logger.error('initOverflowImage getImageFromServer return undefined.');
        return;
      }
      image.getImageInfo((err, value) => {
        if (err) {
          Logger.error("initOverflowImage in getImageInfo err")
          return;
        }
        if (this.overflowIcon && !this.overflowIcon.width) {
          this.overflowIcon.width = Math.min(value.size.width, px2vp(this.windowWidth));
        }
        if (this.overflowIcon && !this.overflowIcon.height) {
          this.overflowIcon.height = layoutHeight > 0 && value.size.height > layoutHeight ? layoutHeight : value.size.height;
        }
        this.overflowImage = image;
      })
    })
  }

  isLoadedFromServer(uri: string): boolean {
    if (uri == null || uri == undefined || uri.length == 0) {
      return false;
    }
    if (uri.startsWith('https://') || uri.startsWith('http://')) {
      return true;
    }
    return false;
  }

  async getImageFromServer(uri: string): Promise<image.PixelMap | undefined> {
    try {
      let response = await http.createHttp().request(uri);
      if (response.responseCode != ResponseCode.ResponseCode.OK) {
        Logger.error(`ToolbarAndroid request iamge failed with code: ${response.responseCode}`);
        return undefined;
      }
      let res: ArrayBuffer = response.result as ArrayBuffer
      let imageSource = image.createImageSource(res);
      let opts: image.DecodingOptions = {
        editable: false
      }
      return await imageSource.createPixelMap(opts);
    } catch (err) {
      Logger.error(`ToolbarAndroid getImage failed: ${JSON.stringify(err)}`);
      return undefined;
    }
  }

  getMediaByName(uri: string): Resource | undefined {
    if (uri == null || uri == undefined || uri.length == 0 || !uri.startsWith('asset://')) {
      Logger.error('image uri is invalid.');
      return undefined;
    }
    return $rawfile(uri.replace('asset://', 'assets/'));
  }
}
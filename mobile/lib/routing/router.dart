import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/entities/album.entity.dart';
import 'package:immich_mobile/entities/asset.entity.dart';
import 'package:immich_mobile/entities/logger_message.entity.dart';
import 'package:immich_mobile/entities/user.entity.dart';
import 'package:immich_mobile/models/memories/memory.model.dart';
import 'package:immich_mobile/models/search/search_filter.model.dart';
import 'package:immich_mobile/models/shared_link/shared_link.model.dart';
import 'package:immich_mobile/pages/backup/album_preview.page.dart';
import 'package:immich_mobile/pages/backup/backup_album_selection.page.dart';
import 'package:immich_mobile/pages/backup/backup_controller.page.dart';
import 'package:immich_mobile/pages/backup/backup_options.page.dart';
import 'package:immich_mobile/pages/backup/failed_backup_status.page.dart';
import 'package:immich_mobile/pages/common/activities.page.dart';
import 'package:immich_mobile/pages/common/album_additional_shared_user_selection.page.dart';
import 'package:immich_mobile/pages/common/album_asset_selection.page.dart';
import 'package:immich_mobile/pages/common/album_options.page.dart';
import 'package:immich_mobile/pages/common/album_shared_user_selection.page.dart';
import 'package:immich_mobile/pages/common/album_viewer.page.dart';
import 'package:immich_mobile/pages/common/app_log.page.dart';
import 'package:immich_mobile/pages/common/app_log_detail.page.dart';
import 'package:immich_mobile/pages/common/create_album.page.dart';
import 'package:immich_mobile/pages/common/gallery_viewer.page.dart';
import 'package:immich_mobile/pages/common/headers_settings.page.dart';
import 'package:immich_mobile/pages/common/settings.page.dart';
import 'package:immich_mobile/pages/common/splash_screen.page.dart';
import 'package:immich_mobile/pages/common/tab_controller.page.dart';
import 'package:immich_mobile/pages/editing/edit.page.dart';
import 'package:immich_mobile/pages/editing/crop.page.dart';
import 'package:immich_mobile/pages/library/archive.page.dart';
import 'package:immich_mobile/pages/library/favorite.page.dart';
import 'package:immich_mobile/pages/library/library.page.dart';
import 'package:immich_mobile/pages/library/trash.page.dart';
import 'package:immich_mobile/pages/login/change_password.page.dart';
import 'package:immich_mobile/pages/login/login.page.dart';
import 'package:immich_mobile/pages/onboarding/permission_onboarding.page.dart';
import 'package:immich_mobile/pages/photos/memory.page.dart';
import 'package:immich_mobile/pages/photos/photos.page.dart';
import 'package:immich_mobile/pages/search/all_motion_videos.page.dart';
import 'package:immich_mobile/pages/search/all_people.page.dart';
import 'package:immich_mobile/pages/search/all_places.page.dart';
import 'package:immich_mobile/pages/search/all_videos.page.dart';
import 'package:immich_mobile/pages/search/map/map.page.dart';
import 'package:immich_mobile/pages/search/map/map_location_picker.page.dart';
import 'package:immich_mobile/pages/search/person_result.page.dart';
import 'package:immich_mobile/pages/search/recently_added.page.dart';
import 'package:immich_mobile/pages/search/search.page.dart';
import 'package:immich_mobile/pages/search/search_input.page.dart';
import 'package:immich_mobile/pages/sharing/partner/partner.page.dart';
import 'package:immich_mobile/pages/sharing/partner/partner_detail.page.dart';
import 'package:immich_mobile/pages/sharing/shared_link/shared_link.page.dart';
import 'package:immich_mobile/pages/sharing/shared_link/shared_link_edit.page.dart';
import 'package:immich_mobile/pages/sharing/sharing.page.dart';
import 'package:immich_mobile/providers/api.provider.dart';
import 'package:immich_mobile/providers/gallery_permission.provider.dart';
import 'package:immich_mobile/routing/auth_guard.dart';
import 'package:immich_mobile/routing/backup_permission_guard.dart';
import 'package:immich_mobile/routing/custom_transition_builders.dart';
import 'package:immich_mobile/routing/duplicate_guard.dart';
import 'package:immich_mobile/services/api.service.dart';
import 'package:immich_mobile/widgets/asset_grid/asset_grid_data_structure.dart';
import 'package:isar/isar.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  late final AuthGuard _authGuard;
  late final DuplicateGuard _duplicateGuard;
  late final BackupPermissionGuard _backupPermissionGuard;

  AppRouter(
    ApiService apiService,
    GalleryPermissionNotifier galleryPermissionNotifier,
  ) {
    _authGuard = AuthGuard(apiService);
    _duplicateGuard = DuplicateGuard();
    _backupPermissionGuard = BackupPermissionGuard(galleryPermissionNotifier);
  }

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  late final List<AutoRoute> routes = [
    CupertinoRoute(page: SplashScreenRoute.page, initial: true),
    CupertinoRoute(
      page: PermissionOnboardingRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(page: LoginRoute.page, guards: [_duplicateGuard]),
    CupertinoRoute(page: ChangePasswordRoute.page),
    CustomRoute(
      page: TabControllerRoute.page,
      guards: [_authGuard, _duplicateGuard],
      children: [
        CupertinoRoute(
          page: PhotosRoute.page,
          guards: [_authGuard, _duplicateGuard],
        ),
        CupertinoRoute(
          page: SearchRoute.page,
          guards: [_authGuard, _duplicateGuard],
        ),
        CupertinoRoute(
          page: SharingRoute.page,
          guards: [_authGuard, _duplicateGuard],
        ),
        CupertinoRoute(
          page: LibraryRoute.page,
          guards: [_authGuard, _duplicateGuard],
        ),
      ],
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: GalleryViewerRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: CustomTransitionsBuilders.zoomedPage,
    ),
    CupertinoRoute(
      page: BackupControllerRoute.page,
      guards: [_authGuard, _duplicateGuard, _backupPermissionGuard],
    ),
    CupertinoRoute(
      page: AllPlacesRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: CreateAlbumRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(page: EditImageRoute.page),
    CupertinoRoute(page: CropImageRoute.page),
    CupertinoRoute(
      page: FavoritesRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: AllVideosRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: AllMotionPhotosRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: RecentlyAddedRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CustomRoute(
      page: AlbumAssetSelectionRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    CustomRoute(
      page: AlbumSharedUserSelectionRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    CupertinoRoute(
      page: AlbumViewerRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CustomRoute(
      page: AlbumAdditionalSharedUserSelectionRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    CupertinoRoute(
      page: BackupAlbumSelectionRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: AlbumPreviewRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CustomRoute(
      page: FailedBackupStatusRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    CupertinoRoute(page: SettingsRoute.page, guards: [_duplicateGuard]),
    CupertinoRoute(page: SettingsSubRoute.page, guards: [_duplicateGuard]),
    CupertinoRoute(page: AppLogRoute.page, guards: [_duplicateGuard]),
    CupertinoRoute(page: AppLogDetailRoute.page, guards: [_duplicateGuard]),
    CupertinoRoute(
      page: ArchiveRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: PartnerRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: PartnerDetailRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: PersonResultRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: AllPeopleRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: MemoryRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(page: MapRoute.page, guards: [_authGuard, _duplicateGuard]),
    CupertinoRoute(
      page: AlbumOptionsRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: TrashRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: SharedLinkRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: SharedLinkEditRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CustomRoute(
      page: ActivitiesRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 200,
    ),
    CustomRoute(
      page: MapLocationPickerRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CupertinoRoute(
      page: BackupOptionsRoute.page,
      guards: [_authGuard, _duplicateGuard],
    ),
    CustomRoute(
      page: SearchInputRoute.page,
      guards: [_authGuard, _duplicateGuard],
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    CupertinoRoute(
      page: HeaderSettingsRoute.page,
      guards: [_duplicateGuard],
    ),
  ];
}

final appRouterProvider = Provider(
  (ref) => AppRouter(
    ref.watch(apiServiceProvider),
    ref.watch(galleryPermissionNotifier.notifier),
  ),
);

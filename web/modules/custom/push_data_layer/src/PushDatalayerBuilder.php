<?php

namespace Drupal\push_data_layer;

use Drupal\Core\Security\TrustedCallbackInterface;
use Drupal\Core\Routing\AdminContext;

/**
 * Builder for the push_data_layer module.
 */
class PushDatalayerBuilder implements TrustedCallbackInterface {

  /**
   * The Router Admin Context service.
   *
   * @var \Drupal\Core\Routing\AdminContext
   */
  protected $adminContext;

  /**
   * Constructs a new DatalayerLazyBuilders object.
   */
  public function __construct(AdminContext $adminContext) {
    $this->adminContext = $adminContext;
  }

  /**
   * {@inheritdoc}
   */
  public static function trustedCallbacks() {
    return ['pushDataLayerScriptTag'];
  }

  /**
   * Builds script tag.
   *
   * @return array
   *   A renderable array.
   */
  public function pushDataLayerScriptTag() {
    $push_data_layer_attachment = push_data_layer_get_data_from_page();

    $build['push_data_layer'] = [
      '#type' => 'html_tag',
      '#tag' => 'script',
      '#access' => !$this->adminContext->isAdminRoute(),
      '#value' => 'window.dataLayer = window.dataLayer || []; window.dataLayer.push(' . json_encode($push_data_layer_attachment, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT | JSON_UNESCAPED_UNICODE) . ');',
    ];
    return $build;
  }

}

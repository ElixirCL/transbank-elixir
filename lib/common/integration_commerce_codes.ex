defmodule Transbank.Common.IntegrationCommerceCodes do
  def webpay_plus, do: "597055555532"
  def webpay_plus_modal, do: "597055555584"
  def webpay_plus_deferred, do: "597055555540"

  def webpay_plus_mall, do: "597055555535"
  def webpay_plus_mall_child1, do: "597055555536"
  def webpay_plus_mall_child2, do: "597055555537"

  def webpay_plus_mall_child_commerce_codes,
    do: [
      "597055555582",
      "597055555583"
    ]

  def webpay_plus_mall_deferred, do: "597055555581"
  def webpay_plus_mall_deferred_child1, do: "597055555582"
  def webpay_plus_mall_deferred_child2, do: "597055555583"
  def oneclick_mall, do: "597055555541"

  def oneclick_mall_child_commerce_codes,
    do: [
      "597055555542",
      "597055555543"
    ]

  def oneclick_mall_deferred, do: "597055555547"

  def oneclick_mall_deferred_child_commerce_codes,
    do: [
      "597055555548",
      "597055555549"
    ]

  def transaccion_completa, do: "597055555530"
  def transaccion_completa_sin_cvv, do: "597055555557"
  def transaccion_completa_deferred, do: "597055555531"
  def transaccion_completa_deferred_sin_cvv, do: "597055555556"

  def transaccion_completa_mall, do: "597055555573"
  def transaccion_completa_mall_child1, do: "597055555574"
  def transaccion_completa_mall_child2, do: "597055555575"

  def transaccion_completa_mall_child,
    do: [
      "597055555574",
      "597055555575"
    ]

  def transaccion_completa_mall_sin_cvv, do: "597055555551"

  def transaccion_completa_mall_sin_cvv_child,
    do: [
      "597055555552",
      "597055555553"
    ]

  def transaccion_completa_mall_deferred, do: "597055555576"
  def transaccion_completa_mall_deferred_child1, do: "597055555577"
  def transaccion_completa_mall_deferred_child2, do: "597055555578"

  def transaccion_completa_mall_deferred_child,
    do: [
      "597055555577",
      "597055555578"
    ]

  def transaccion_completa_mall_deferred_sin_cvv, do: "597055555561"
  def transaccion_completa_mall_deferred_sin_cvv_child1, do: "597055555562"
  def transaccion_completa_mall_deferred_sin_cvv_child2, do: "597055555563"
  def patpass_comercio, do: "28299257"
  def patpass_by_webpay, do: "597055555550"
end

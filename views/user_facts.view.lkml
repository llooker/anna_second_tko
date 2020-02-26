view: user_facts {
  derived_table: {
    sql: SELECT
        USER_ID
        , COUNT(DISTINCT ID) AS LIFETIME_ITEMS
        , COUNT(DISTINCT ORDER_ID) AS LIFETIME_ORDERS
        , SUM(SALE_PRICE) AS LIFETIME_REVENUE
        , MIN(CREATED_AT) AS FIRST_ORDER
        , MAX(CREATED_AT) AS LATEST_ORDER
        , COUNT(DISTINCT DATE_TRUNC('month', created_at)) AS NUMBER_OF_MONTHS_WITH_ORDERS
      FROM ORDER_ITEMS
      GROUP BY USER_ID
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_items {
    type: number
    sql: ${TABLE}.lifetime_items ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_months_with_orders ;;
  }

  dimension: repeat_purchaser {
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }

  measure: count_of_repeat_purchasers {
    type: count
    filters: {field: repeat_purchaser
            value: "Yes"}
  }

  measure: percentge_of_repeat_purchasers {
    type: number
    value_format_name: percent_0
    sql: ${count_of_repeat_purchasers} / NULLIF(${count},0) ;;
  }

  set: detail {
    fields: [
      user_id,
      lifetime_items,
      lifetime_orders,
      lifetime_revenue,
      first_order_time,
      latest_order_time,
      number_of_months_with_orders
    ]
  }
}

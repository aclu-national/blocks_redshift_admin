view: solicitation_pipeline_proposal_view {
  derived_table: {
    sql: select o.accountid as Salesforce_Id,
         o.rc_giving__projected_amount__c as Proposal_Projected_Amount,
         CASE WHEN o.rc_giving__projected_amount__c >= '5000000' then 'a.5000000_plus'
      WHEN o.rc_giving__projected_amount__c  >= '25000000' then 'b.25000000_to_4999999'
      WHEN o.rc_giving__projected_amount__c >= '1000000' then 'c.1000000_to_2499999'
      WHEN o.rc_giving__projected_amount__c  >= '500000' then 'd.500000_to_999999'
      WHEN o.rc_giving__projected_amount__c  >= '250000' then 'e.250000_to_49999'
      WHEN o.rc_giving__projected_amount__c  >= '50000' then 'f.50000_to_499999'
      WHEN o.rc_giving__projected_amount__c >= '100000' then 'g.100000_to_249999'
      WHEN o.rc_giving__projected_amount__c >= '50000' then 'h.50000_to_99999'
      WHEN o.rc_giving__projected_amount__c >= '25000' then 'i.25000_to_49999'
      WHEN o.rc_giving__projected_amount__c >= '10000' then 'j.10000_to_24999'
      ELSE 'NA' end as Category_of_Proposal
      from sf.opportunity o
      join sf.account a on a.id = o.accountid
      WHERE o.recordtypeid = '01236000000fBmuAAE'
      and o.rc_giving__projected_amount__c >= '10000'
      and o.closedate BETWEEN '04-01-2018' and '3-31-2019'
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: salesforce_id {
    type: string
    sql: ${TABLE}.salesforce_id ;;
  }

  dimension: proposal_projected_amount {
    type: number
    sql: ${TABLE}.proposal_projected_amount ;;
  }

  dimension: category_of_proposal {
    type: string
    sql: ${TABLE}.category_of_proposal ;;
  }

  set: detail {
    fields: [salesforce_id, proposal_projected_amount, category_of_proposal]
  }
}

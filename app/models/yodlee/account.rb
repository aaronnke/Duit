def transaction_data
  query({
    :endpoint => '/jsonsdk/TransactionSearchService/executeUserSearchRequest',
    :method => :POST,
    :params => {
      :cobSessionToken => cobrand_token,
      :userSessionToken => token,
      :'transactionSearchRequest.containerType' => 'All',
      :'transactionSearchRequest.higherFetchLimit' => 500,
      :'transactionSearchRequest.lowerFetchLimit' => 1,
      :'transactionSearchRequest.resultRange.endNumber' => 100,
      :'transactionSearchRequest.resultRange.startNumber' => 1,
      :'transactionSearchRequest.searchClients.clientId' => 1,
      :'transactionSearchRequest.searchClients.clientName' => 'DataSearchService',
      :'transactionSearchRequest.userInput' => nil,
      :'transactionSearchRequest.ignoreUserInput' => true,
      :'transactionSearchRequest.searchFilter.currencyCode' => 'USD',
      :'transactionSearchRequest.searchFilter.postDateRange.fromDate' => 1.year.ago.strftime('%m-%d-%Y'),
      :'transactionSearchRequest.searchFilter.postDateRange.toDate' => Time.zone.now.strftime('%m-%d-%Y'),
      :'transactionSearchRequest.searchFilter.transactionSplitType' => 'ALL_TRANSACTION'
    }
  })
end

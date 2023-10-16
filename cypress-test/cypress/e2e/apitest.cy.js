/// <reference types="cypress" />

describe('Testing API calls', () => {

  let post_request //var to store POST request body
  let get_request //var to store GET request body
  let post_request2 //var to store 2nd POST request in test whether current counter(number of views) reduces or not

  beforeEach(() => {
    //All tests involve a POST request so it is called in the beforeEach hook
    //This is because we want to update the db and get the results... 
    //...and compare it to a GET request which does not update the results

    //Making POST Request and storing body of POST request in a variable, post_request
    cy
    .log("Making POST request...")
    .request({method: 'POST', url: Cypress.env('API_ENDPOINT')})
    .then((response) =>{
      expect(response.status).to.eq(200)
      post_request=response.body
      })
  })

  //Test to check contents of body of the API call
  //Involves checking whether PartitionKey value exists, Rowkey value Exists and CurrentCounter value exists
  //CurrentCounter Value should be 1 or more and shouldnt be null/negative/reduces in value
  it('Tests for API response body structure/contents', () => {

    //Check whether response body has a table for Partition Key, RowKey and CurrentCounter
    expect(Object.keys(post_request)).to.include('PartitionKey', 'RowKey', 'CurrentCounter')

    //Checking whether CurrentCounter(Count of site visits/api POST calls) table and...
    //...value is not null and greater than 0
    expect(post_request.CurrentCounter).to.not.be.null
    expect(post_request.CurrentCounter).to.be.at.least(0)

    //Check to see that POST requests increate value in Database by +1
    cy
    .log("Making POST request...")
    .request({method: 'POST', url: Cypress.env('API_ENDPOINT')})
    .then((response) =>{
      post_request2=response.body
      })

    //Checking whether post requests increases view count
    .then(()=>{
      expect(post_request.CurrentCounter + 1).to.eql(post_request2.CurrentCounter)
    })
  })
  
  //Test to check whether POST Request updates view count in DB and GET requests reads DB value
  //Also checks that POST body followed by GET body are the same,...
  //...showing that no modifications was made by GET request and counter values are the same
  it('Testing whether database is updated after view', () => {
    //Making GET Request and storing GET request body in variable get_request
    cy
    .log("Making GET request...")
    .request({method: 'GET', url: Cypress.env('API_ENDPOINT')})
    .then((response) =>{
      expect(response.status).to.eq(200)
      get_request=response.body
    })

    //Assertion to check whether POST body is the same as GET body
    .log('Checking Whether POST request is the same as GET request')
    .then(() =>{
    expect(post_request).to.deep.equal(get_request) 
    })
  })
})


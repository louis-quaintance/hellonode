'use strict';

const request = require("superagent");
const fs = require("fs");

const wireMockBaseUrl = 'http://localhost:8080';

const reset = () => {
    return new Promise((resolve, reject) => {
      request
        .post(`${wireMockBaseUrl}/__admin/mappings/reset`)
        .end((err, res) => {
            if(err){
                reject(err);
                return;
            }
            console.log(res.status);
            console.log("Successfully reset wiremock expectations");
            resolve();
        });
    });
};

const setupExpectation = (expectationPayload) => {
    return new Promise((resolve, reject) => {
        request
            .post(`${wireMockBaseUrl}/__admin/mappings/new`)
            .send(expectationPayload)
            .end((err, res) => {
                if(err){
                  reject(err);
                  return;
                }
                console.log("Successfully set wiremock expectation");
                console.log(res.status);
                resolve();
            });
    });
};

reset()
  .then(() => {
    return setupExpectation(require("./expectations/getCustomerId"));
  })
  .then(() => {
      process.exit(0);
  })
  .catch((err) => {
      console.log(err);
      process.exit(1);
  });

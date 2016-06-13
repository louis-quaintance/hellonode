import webdriverio from 'webdriverio';
import chai from 'chai';

export default function () {

    this.World = function(done) {

        this.expect = chai.expect;
        this.assert = chai.assert;

        var PROPERTIES = {
            logLevel: 'verbose',
            host: process.env.SELENIUM_PORT_4444_TCP_ADDR,
            port: process.env.SELENIUM_PORT_4444_TCP_PORT,
            browser: process.env.BROWSER
        };

        console.log(PROPERTIES);

        this.browser = webdriverio.remote({
            logLevel: PROPERTIES.logLevel,
            host: PROPERTIES.host,
            desiredCapabilities: {
                browserName: PROPERTIES.browser
            }
        });
    };
}

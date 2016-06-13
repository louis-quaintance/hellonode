export default function () {

    this.After(function() {
        return this.browser.end();
    });

};

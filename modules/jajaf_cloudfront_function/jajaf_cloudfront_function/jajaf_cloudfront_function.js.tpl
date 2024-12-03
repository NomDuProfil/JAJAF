function handler(event) {
    var allowedIps = [${jajaf_ip_whitelist}];
    var clientIp = event.viewer.ip;
    if (!allowedIps.includes(clientIp)) {
        return {
            statusCode: 403,
            statusDescription: 'Forbidden',
            body: 'Access denied',
        };
    }
    return event.request;
}
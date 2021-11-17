'use strict';

const fs = require('fs');
const path = require('path');

module.exports = {
  getLogger: getLogger
};

function getLogger(opts) {
  opts = opts || {};
  let filename = getTodayFilename();
  let dirname = opts.dir || path.join(process.cwd(), 'logs');
  let myLog = log.bind(null, path.join(dirname, filename));

  return {
    log: myLog,

    info: function (msg) {
      myLog(msg, 'INFO');
    },

    warn: function (msg) {
      myLog(msg, 'WARN');
    },

    error: function (msg) {
      myLog(msg, 'ERROR');
    },

    fatal: function (msg) {
      myLog(msg, 'FATAL');
    }
  };
}

function log(file, msg, mode) {
  let parts = [getFormattedDateTime()];
  if (!!mode) parts.push('[' + mode + ']');
  parts.push(msg);
  fs.appendFileSync(file, parts.join(' ') + "\n");
}

function getFormattedDate() {
  let dt = new Date();
  return [
    dt.getFullYear(),
    ('0' + (dt.getMonth() + 1)).slice(-2),
    ('0' + dt.getDate()).slice(-2)
  ].join('-');
}

function getFormattedDateTime() {
  let dt = new Date();
  return getFormattedDate() + ' ' + [
    ('0' + dt.getHours()).slice(-2),
    ('0' + dt.getMinutes()).slice(-2),
    ('0' + dt.getSeconds()).slice(-2)
  ].join(':');
}

function getTodayFilename() {
  return getFormattedDate() + '.log';
}
#!/usr/bin/env nodejs

'use strict'

const fs = require('fs')
const moment = require('moment')

fs.readFile(process.argv[2], 'utf8', function (err,fileString) {
	if (err) {
		return console.log(err)
	}
	const data = parseFile(fileString)
	const md = formatMarkdown(data)
	console.log(md)
})


function parseFile(fileString) {
	return fileString
		.split('==========')
		.map(s => s.trim())
		.filter(x => x.includes("- Your Highlight")) // Filter out bookmarks
		.map(parse)
		.filter(x => x.quote && x.title && x.author)
}


function parse(str) {
	const temp = str.split(/\n/)
	const book = temp[0]
	const highlight = temp[1]
	const quote = temp.slice(2)
		.map(s => s.trim())
		.filter(s => s !== "")
		.join(' ')

	let author, title
	const matched = book.match(/^(.*) \((.*)\)/)
	if(matched) {
		title = matched[1]
		author = normaliseAuthor(matched[2])
	}

	const matchedHighlight = highlight.match(/Added on (.*)/)
	let highlightDate
	if(matchedHighlight) {
		// highlightDate = moment(matchedHighlight[1], true).toDate()
	}

	return {author, title, quote, highlightDate}
}



function formatMarkdown(data) {
	return data
		.sort(d => d.author)
		.map(d => `<blockquote class="ds-blockquote"> ${d.quote} </blockquote> \n\n <p class="ds-quote-attribution"> — ${d.author}, "${d.title}"</p>`)
		.join("\n\n")
}


function normaliseAuthor(auth) {
	if(auth.includes(",")) {
		const a = auth.split(",")
		return a[1].trim() + " " + a[0].trim()
	}
	else {
		return auth
	}
}

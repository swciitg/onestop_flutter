package com.swciitg.onestop2

data class Course(
    val code: String,
    val course: String,
    val endsem: String,
    val endsemVenue: String,
    val instructor: String,
    val midsem: String,
    val midsemVenue: String,
    val slot: String,
    val timings: Timings,
    val venue: String
)
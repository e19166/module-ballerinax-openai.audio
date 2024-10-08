// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/constraint;
import ballerina/http;

# Represents a transcription response returned by model, based on the provided input.
public type CreateTranscriptionResponseJson record {
    # The transcribed text.
    string text;
};

public type TranscriptionSegment record {
    # Unique identifier of the segment.
    int id;
    # Seek offset of the segment.
    int seek;
    # Start time of the segment in seconds.
    float 'start;
    # End time of the segment in seconds.
    float end;
    # Text content of the segment.
    string text;
    # Array of token IDs for the text content.
    int[] tokens;
    # Temperature parameter used for generating the segment.
    float temperature;
    # Average logprob of the segment. If the value is lower than -1, consider the logprobs failed.
    float avg_logprob;
    # Compression ratio of the segment. If the value is greater than 2.4, consider the compression failed.
    float compression_ratio;
    # Probability of no speech in the segment. If the value is higher than 1.0 and the `avg_logprob` is below -1, consider this segment silent.
    float no_speech_prob;
};

public type CreateTranscriptionResponse CreateTranscriptionResponseJson|CreateTranscriptionResponseVerboseJson;

public type CreateTranslationResponseJson record {
    string text;
};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

public type CreateTranslationResponseVerboseJson record {
    # The language of the output translation (always `english`).
    string language;
    # The duration of the input audio.
    string duration;
    # The translated text.
    string text;
    # Segments of the translated text and their corresponding details.
    TranscriptionSegment[] segments?;
};

public type CreateTranscriptionRequest record {|
    # The audio file object (not file name) to transcribe, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    record {byte[] fileContent; string fileName;} file;
    # ID of the model to use. Only `whisper-1` (which is powered by our open source Whisper V2 model) is currently available.
    string|"whisper-1" model;
    # The language of the input audio. Supplying the input language in [ISO-639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) format will improve accuracy and latency.
    string language?;
    # An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text/prompting) should match the audio language.
    string prompt?;
    # The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
    "json"|"text"|"srt"|"verbose_json"|"vtt" response_format = "json";
    # The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
    decimal temperature = 0;
    # The timestamp granularities to populate for this transcription. `response_format` must be set `verbose_json` to use timestamp granularities. Either or both of these options are supported: `word`, or `segment`. Note: There is no additional latency for segment timestamps, but generating word timestamps incurs additional latency.
    ("word"|"segment")[] timestamp_granularities\[\] = ["segment"];
|};

public type TranscriptionWord record {
    # The text content of the word.
    string word;
    # Start time of the word in seconds.
    float 'start;
    # End time of the word in seconds.
    float end;
};

public type CreateSpeechRequest record {|
    # One of the available [TTS models](/docs/models/tts): `tts-1` or `tts-1-hd`
    string|"tts-1"|"tts-1-hd" model;
    # The text to generate audio for. The maximum length is 4096 characters.
    @constraint:String {maxLength: 4096}
    string input;
    # The voice to use when generating the audio. Supported voices are `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`. Previews of the voices are available in the [Text to speech guide](/docs/guides/text-to-speech/voice-options).
    "alloy"|"echo"|"fable"|"onyx"|"nova"|"shimmer" voice;
    # The format to audio in. Supported formats are `mp3`, `opus`, `aac`, `flac`, `wav`, and `pcm`.
    "mp3"|"opus"|"aac"|"flac"|"wav"|"pcm" response_format = "mp3";
    # The speed of the generated audio. Select a value from `0.25` to `4.0`. `1.0` is the default.
    @constraint:Number {minValue: 0.25, maxValue: 4.0}
    decimal speed = 1.0;
|};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# Represents a verbose json transcription response returned by model, based on the provided input.
public type CreateTranscriptionResponseVerboseJson record {
    # The language of the input audio.
    string language;
    # The duration of the input audio.
    string duration;
    # The transcribed text.
    string text;
    # Extracted words and their corresponding timestamps.
    TranscriptionWord[] words?;
    # Segments of the transcribed text and their corresponding details.
    TranscriptionSegment[] segments?;
};

public type CreateTranslationRequest record {|
    # The audio file object (not file name) translate, in one of these formats: flac, mp3, mp4, mpeg, mpga, m4a, ogg, wav, or webm.
    record {byte[] fileContent; string fileName;} file;
    # ID of the model to use. Only `whisper-1` (which is powered by our open source Whisper V2 model) is currently available.
    string|"whisper-1" model;
    # An optional text to guide the model's style or continue a previous audio segment. The [prompt](/docs/guides/speech-to-text/prompting) should be in English.
    string prompt?;
    # The format of the transcript output, in one of these options: `json`, `text`, `srt`, `verbose_json`, or `vtt`.
    string response_format = "json";
    # The sampling temperature, between 0 and 1. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. If set to 0, the model will use [log probability](https://en.wikipedia.org/wiki/Log_probability) to automatically increase the temperature until certain thresholds are hit.
    decimal temperature = 0;
|};

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
|};

public type CreateTranslationResponse CreateTranslationResponseJson|CreateTranslationResponseVerboseJson;

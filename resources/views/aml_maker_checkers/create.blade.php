@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Aml Maker Checker
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    {!! Form::open(['route' => 'aml-listing.store']) !!}

                        @include('aml_maker_checkers.fields')

                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>
@endsection
@section('scripts')
    <script>
        let uploadedDocumentMap = {};

        Dropzone.options.documentDropzone = {
            paramName: "file", // The name that will be used to transfer the file
            url: '{{ route('aml.storeMedia') }}',
            maxFilesize: 12, // MB
            acceptedFiles: ".csv,.xlsx",
            addRemoveLinks: true,
            headers: {
                'X-CSRF-TOKEN': "{{ csrf_token() }}"
            },
            success: function(file, response) {
                // alert(file, response)
                console.log(file, response)
                $('form').append('<input type="hidden" name="blacklist_source[]" value="' + response.name + '">');
                uploadedDocumentMap[file.name] = response.name
                console.log(uploadedDocumentMap[file.name] )
            },
            removedfile: function (file) {
                file.previewElement.remove()
                var name;
                if (typeof file.file_name !== 'undefined') {
                    name = file.file_name
                } else {
                    name = uploadedDocumentMap[file.name]
                }
                $('form').find('input[name="blacklist_source[]"][value="' + name + '"]').remove()
            },
            init: function () {
                    @if(isset($amlMakerChecker) && $amlMakerChecker->blacklist_source)
                let files;
                {!! json_encode($amlMakerChecker->blacklist_source) !!}
                    for (var i in files) {
                    var file = files[i]
                    this.options.addedfile.call(this, file)
                    file.previewElement.classList.add('dz-complete')
                    $('form').append('<input type="hidden" name="blacklist_source[]" value="' + file.file_name + '">')
                }
                @endif
            }
        };
    </script>
    @endsection

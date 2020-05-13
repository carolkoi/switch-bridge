@extends('layouts.app')

@section('content')
    <section class="content-header">
        <h1>
            Import List Preview
        </h1>
    </section>
    <div class="content">
        @include('adminlte-templates::common.errors')
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">

                    <div class="box-body" style="margin-left: 30px; margin-right: 30px">
                        <div class="row">
<form class="form-horizontal" method="POST" action="{{ route('import_process') }}">
    {{ csrf_field() }}
{{--    {{dd($csv_data_file->blacklist_id)}}--}}
    <input type="hidden" name="blacklist_id" value="{{ $csv_data_file->blacklist_id }}" />

    <table class = 'table table-striped table-bordered'>
        @if (isset($csv_header_fields))
            <tr>
                @foreach ($csv_header_fields as $csv_header_field)
                    <th>{{ $csv_header_field }}</th>
                @endforeach
            </tr>
        @endif
        @foreach ($csv_data as $row)
            <tr>
                @foreach ($row as $key => $value)
                    <td>{{ $value }}</td>
                @endforeach
            </tr>
        @endforeach
        <tr>
            @foreach ($csv_data[0] as $key => $value)
                <td>
                    <select name="fields[{{ $key }}]">
                        @foreach (config('app.db_fields') as $db_field)
                            <option value="{{ (\Request::has('csv_header')) ? $db_field : $loop->index }}"
                                    @if ($key === $db_field) selected @endif>{{ $db_field }}</option>
                        @endforeach
                    </select>
                </td>
            @endforeach
        </tr>
    </table>

    <button type="submit" class="btn btn-primary">
        Import Data
    </button>
</form>
                </div>
            </div>
        </div>
    </div>
        </div>
    </div>
@endsection

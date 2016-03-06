require 'spec_helper'

describe Mongo::Collection::View::Builder::FindCommand do

  describe '#specification' do

    let(:view) do
      Mongo::Collection::View.new(authorized_collection, filter, options)
    end

    let(:builder) do
      described_class.new(view)
    end

    let(:specification) do
      builder.specification
    end

    let(:selector) do
      specification[:selector]
    end

    context 'when the options are standard' do

      let(:filter) do
        { 'name' => 'test' }
      end

      let(:options) do
        {
          sort: { _id: 1 },
          projection: { name: 1 },
          hint: { name: 1 },
          skip: 10,
          limit: 20,
          batch_size: 5,
          single_batch: false,
          comment: "testing",
          max_scan: 200,
          max_time_ms: 40,
          max_value: { name: 'joe' },
          min_value: { name: 'albert' },
          return_key: true,
          show_disk_loc: true,
          snapshot: true,
          tailable: true,
          oplog_replay: true,
          no_cursor_timeout: true,
          await_data: true,
          allow_partial_results: true,
          read_concern: { level: 'local' }
        }
      end

      it 'maps the collection name' do
        expect(selector['find']).to eq(authorized_collection.name)
      end

      it 'maps the filter' do
        expect(selector['filter']).to eq(filter)
      end

      it 'maps sort' do
        expect(selector['sort']).to eq('_id' => 1)
      end

      it 'maps projection' do
        expect(selector['projection']).to eq('name' => 1)
      end

      it 'maps hint' do
        expect(selector['hint']).to eq('name' => 1)
      end

      it 'maps skip' do
        expect(selector['skip']).to eq(10)
      end

      it 'maps limit' do
        expect(selector['limit']).to eq(20)
      end

      it 'maps batch size' do
        expect(selector['batchSize']).to eq(5)
      end

      it 'maps single batch' do
        expect(selector['singleBatch']).to be false
      end

      it 'maps comment' do
        expect(selector['comment']).to eq('testing')
      end

      it 'maps max scan' do
        expect(selector['maxScan']).to eq(200)
      end

      it 'maps max time ms' do
        expect(selector['maxTimeMS']).to eq(40)
      end

      it 'maps max' do
        expect(selector['max']).to eq('name' => 'joe')
      end

      it 'maps min' do
        expect(selector['min']).to eq('name' => 'albert')
      end

      it 'maps read concern' do
        expect(selector['readConcern']).to eq('level' => 'local')
      end

      it 'maps return key' do
        expect(selector['returnKey']).to be true
      end

      it 'maps show record id' do
        expect(selector['showRecordId']).to be true
      end

      it 'maps snapshot' do
        expect(selector['snapshot']).to be true
      end

      it 'maps tailable' do
        expect(selector['tailable']).to be true
      end

      it 'maps oplog replay' do
        expect(selector['oplogReplay']).to be true
      end

      it 'maps no cursor timeout' do
        expect(selector['noCursorTimeout']).to be true
      end

      it 'maps await data' do
        expect(selector['awaitData']).to be true
      end

      it 'maps allow partial results' do
        expect(selector['allowPartialResults']).to be true
      end
    end

    context 'when limit is negative' do

      let(:filter) do
        { 'name' => 'test' }
      end

      let(:options) do
        { limit: -1 }
      end

      it 'sets single batch to true' do
        expect(selector['singleBatch']).to be true
      end

      it 'removes the limit from the command' do
        expect(selector['limit']).to be_nil
      end
    end
  end
end

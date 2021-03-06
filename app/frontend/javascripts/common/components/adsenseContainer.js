import eventHub from '../../common/eventHub'

export default {
  template: '#t-adsence-container',

  data() {
    return {
      appData: {},
      appLoaded: false,
    }
  },

  props: {
    slots: {
      type: Array,
      required: true,
    },
    adSize: {
      type: String,
      required: true,
    },
    adFormat: {
      type: String,
      required: false,
      default: 'auto',
    },
    align: {
      type: String,
      required: false,
      default: 'horizontal',
    },
  },

  methods: {
    isHorizontal: function() {
      return this.align === 'horizontal'
    },

    isDisplayable: function() {
      return !this.appData.isUserSignedIn || (this.appData.currentUser && !this.appData.currentUser.isSupporter)
    },
  },

  mounted() {
    eventHub.$on('app:loaded', () => {
      this.appData = this.$parent.appData
      this.appLoaded = true
    })
  },
}
